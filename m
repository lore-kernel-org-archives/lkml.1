Return-Path: <linux-kernel-owner+w=401wt.eu-S965750AbXCFCRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965750AbXCFCRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 21:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965747AbXCFCQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 21:16:50 -0500
Received: from mx1.suse.de ([195.135.220.2]:47918 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933858AbXCFCQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 21:16:26 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 6 Mar 2007 13:15:10 +1100
Message-Id: <1070306021510.26907@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 002 of 4] knfsd: Remove CONFIG_IPV6 ifdefs from sunrpc server code.
References: <20070306131103.26638.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


They don't really save that much, and aren't worth the hassle.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./include/linux/sunrpc/svc.h |    2 --
 ./net/sunrpc/svcsock.c       |   13 +++----------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff .prev/include/linux/sunrpc/svc.h ./include/linux/sunrpc/svc.h
--- .prev/include/linux/sunrpc/svc.h	2007-03-06 11:02:46.000000000 +1100
+++ ./include/linux/sunrpc/svc.h	2007-03-06 11:12:40.000000000 +1100
@@ -194,9 +194,7 @@ static inline void svc_putu32(struct kve
 
 union svc_addr_u {
     struct in_addr	addr;
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
     struct in6_addr	addr6;
-#endif
 };
 
 /*

diff .prev/net/sunrpc/svcsock.c ./net/sunrpc/svcsock.c
--- .prev/net/sunrpc/svcsock.c	2007-03-06 11:10:09.000000000 +1100
+++ ./net/sunrpc/svcsock.c	2007-03-06 11:12:40.000000000 +1100
@@ -131,13 +131,13 @@ static char *__svc_print_addr(struct soc
 			NIPQUAD(((struct sockaddr_in *) addr)->sin_addr),
 			htons(((struct sockaddr_in *) addr)->sin_port));
 		break;
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+
 	case AF_INET6:
 		snprintf(buf, len, "%x:%x:%x:%x:%x:%x:%x:%x, port=%u",
 			NIP6(((struct sockaddr_in6 *) addr)->sin6_addr),
 			htons(((struct sockaddr_in6 *) addr)->sin6_port));
 		break;
-#endif
+
 	default:
 		snprintf(buf, len, "unknown address type: %d", addr->sa_family);
 		break;
@@ -449,9 +449,7 @@ svc_wake_up(struct svc_serv *serv)
 
 union svc_pktinfo_u {
 	struct in_pktinfo pkti;
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 	struct in6_pktinfo pkti6;
-#endif
 };
 
 static void svc_set_cmsg_data(struct svc_rqst *rqstp, struct cmsghdr *cmh)
@@ -467,7 +465,7 @@ static void svc_set_cmsg_data(struct svc
 			cmh->cmsg_len = CMSG_LEN(sizeof(*pki));
 		}
 		break;
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+
 	case AF_INET6: {
 			struct in6_pktinfo *pki = CMSG_DATA(cmh);
 
@@ -479,7 +477,6 @@ static void svc_set_cmsg_data(struct svc
 			cmh->cmsg_len = CMSG_LEN(sizeof(*pki));
 		}
 		break;
-#endif
 	}
 	return;
 }
@@ -730,13 +727,11 @@ static inline void svc_udp_get_dest_addr
 		rqstp->rq_daddr.addr.s_addr = pki->ipi_spec_dst.s_addr;
 		break;
 		}
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 	case AF_INET6: {
 		struct in6_pktinfo *pki = CMSG_DATA(cmh);
 		ipv6_addr_copy(&rqstp->rq_daddr.addr6, &pki->ipi6_addr);
 		break;
 		}
-#endif
 	}
 }
 
@@ -985,11 +980,9 @@ static inline int svc_port_is_privileged
 	case AF_INET:
 		return ntohs(((struct sockaddr_in *)sin)->sin_port)
 			< PROT_SOCK;
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 	case AF_INET6:
 		return ntohs(((struct sockaddr_in6 *)sin)->sin6_port)
 			< PROT_SOCK;
-#endif
 	default:
 		return 0;
 	}
