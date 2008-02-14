Return-Path: <linux-kernel-owner+w=401wt.eu-S935032AbYBNBAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935032AbYBNBAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934337AbYBNBAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:00:33 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:57379 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934293AbYBNBAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:00:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=UER56aJG0NHVlN4L4o0saUl1hbHY8R8lcEFezWPEY+jNuXkb8smmN9GFewrkMjTDYLVZ1xYywVqg1mSFMw00qvZXWgNtDqGoormkldmCbF/PhLxLc/BqvzUFjr+JG6Ft+yq/5etObXECm0grs8gWtTXuTbuRGJoLwu/8HHAaEco=
Message-ID: <b6a2187b0802131700k3263f4dam30d170208844c9a9@mail.gmail.com>
Date: Thu, 14 Feb 2008 09:00:29 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>,
       "Krzysztof Piotr Oledzki" <ole@ans.pl>
Subject: nf_conntrack - still missing one critical patch
Cc: lkml <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       cups-bugs <cups-bugs@easysw.com>,
       "Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jozsef, Krzysztof

Have you had a chance to take a look at this missing bit?

Thanks,
Jeff.


On Feb 10, 2008 11:06 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>
> On Feb 5, 2008 9:47 PM, Patrick McHardy wrote:
> >> On Feb 5, 2008 4:16 PM, Jozsef Kadlecsik wrote:
> >> Patrick, I suppose you need a patch against the latest git, don't you?
> > Yes, please. I'll take you first patch for -stable though if you
> > send me a Signed-off-by: line.
>
> Please note the lastest git commit is missing one part (which was in
> Jozsef's original patch).
>
>         commit b2155e7f70b3f058efe94c0c459db023b05057bd
>         Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
>         Date:   Thu Feb 7 17:54:56 2008 -0800
>
>             [NETFILTER]: nf_conntrack: TCP conntrack reopening fix
>
>
> I've tested the following missing patch, and it solves the cups slow
> printing problem.
>
>
> Thanks,
> Jeff
>
> --- a/net/netfilter/nf_conntrack_proto_tcp.c.org        2008-02-10 22:45:49 +0800
> +++ a/net/netfilter/nf_conntrack_proto_tcp.c    2008-02-10 22:45:56 +0800
> @@ -945,7 +945,7 @@
>
>         ct->proto.tcp.state = new_state;
>         if (old_state != new_state
> -           && new_state == TCP_CONNTRACK_CLOSE)
>
> +           && new_state == TCP_CONNTRACK_FIN_WAIT)
>                 ct->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
>         timeout = ct->proto.tcp.retrans >= nf_ct_tcp_max_retrans
>                   && tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans
>
