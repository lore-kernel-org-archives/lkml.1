Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbYCSXe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbYCSXe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939512AbYCSWGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:06:17 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:4408 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161553AbYCSWGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:06:15 -0400
Message-ID: <7e0fb38c0803181635t7b629bc4x707e4083b1c81edf@mail.gmail.com>
Date: Tue, 18 Mar 2008 19:35:08 -0400
From: "Eric Paris" <eparis@parisplace.org>
To: "Pavel Emelyanov" <xemul@openvz.org>
Subject: Re: [PATCH] Audit: netlink socket can be auto-bound to pid other than current->pid
Cc: linux-audit@redhat.com, "Thomas Graf" <tgraf@suug.ch>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       aviro@redhat.com, sgrubb@redhat.com, akpm@osdl.org
In-Reply-To: <7e0fb38c0803181629u4a6ff1d6ye83881ddf0e96d48@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47DF8A30.5010602@openvz.org>
	 <7e0fb38c0803181629u4a6ff1d6ye83881ddf0e96d48@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/18/08, Eric Paris <eparis@parisplace.org> wrote:
> On 3/18/08, Pavel Emelyanov <xemul@openvz.org> wrote:

>  >  @@ -626,6 +628,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  >                                                         sid, 1);
>  >
>  >                         audit_pid = new_pid;
>  >  +                       audit_nlk_pid = NETLINK_CB(skb).pid;
>  >                 }
>  >                 if (status_get->mask & AUDIT_STATUS_RATE_LIMIT)
>  >                         err = audit_set_rate_limit(status_get->rate_limit,

Shouldn't the above be:

if (audit_pid)
    audit_nlk_pid = NETLINK_CB(skb).pid;
else
   audit_nlk_pid = 0;

otherwise I don't see how you can cleanly stop the userspace auditd.....
