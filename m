Return-Path: <linux-kernel-owner+w=401wt.eu-S932256AbXCETCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256AbXCETCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 14:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932255AbXCETCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 14:02:00 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:36653 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbXCETB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 14:01:59 -0500
From: Olaf Kirch <olaf.kirch@oracle.com>
To: nfs@lists.sourceforge.net
Subject: Re: [NFS] [PATCH 001 of 3] knfsd: Use recv_msg to get peer address for NFSD instead of code-copying
Date: Mon, 5 Mar 2007 19:59:55 +0100
User-Agent: KMail/1.9.1
Cc: NeilBrown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070302151748.5226.patches@notabene> <1070302042825.5760@suse.de>
In-Reply-To: <1070302042825.5760@suse.de>
Organization: Oracle
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703051959.56914.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Neil,

here's another minor comment:

On Friday 02 March 2007 05:28, NeilBrown wrote:
> +static inline void svc_udp_get_dest_address(struct svc_rqst *rqstp,
> +					    struct cmsghdr *cmh)
>  {
>  	switch (rqstp->rq_sock->sk_sk->sk_family) {
>  	case AF_INET: {
> +		struct in_pktinfo *pki = CMSG_DATA(cmh);
> +		rqstp->rq_daddr.addr.s_addr = pki->ipi_spec_dst.s_addr;
>  		break;
> +		}
...

The daddr that is extracted here will only ever be used to build
another PKTINFO cmsg when sending the reply. So it would be
much easier to just store the raw control message in the svc_rqst,
without looking at its contents, and send it out along with the reply,
unchanged.

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
