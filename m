Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbYKEMfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbYKEMfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 07:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbYKEMfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 07:35:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33106 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbYKEMfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 07:35:19 -0500
Date: Wed, 5 Nov 2008 13:35:06 +0100
From: Michal Schmidt <mschmidt@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       netdev@vger.kernel.org
Subject: [PATCH] selinux: recognize netlink messages for 'ip addrlabel'
Message-ID: <20081105133506.203b48d6@leela>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In enforcing mode '/sbin/ip addrlabel' results in a SELinux error:
type=SELINUX_ERR msg=audit(1225698822.073:42): SELinux:  unrecognized
netlink message type=74 for sclass=43

The problem is missing RTM_*ADDRLABEL entries in SELinux's netlink
message types table.

Reported in https://bugzilla.redhat.com/show_bug.cgi?id=469423

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
---
 security/selinux/nlmsgtab.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index ff59c0c..4ed7bab 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -63,6 +63,9 @@ static struct nlmsg_perm nlmsg_route_perms[] =
 	{ RTM_GETANYCAST,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
 	{ RTM_GETNEIGHTBL,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
 	{ RTM_SETNEIGHTBL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_NEWADDRLABEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_DELADDRLABEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_GETADDRLABEL,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
 };
 
 static struct nlmsg_perm nlmsg_firewall_perms[] =
-- 
1.6.0.3

