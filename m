Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYIZDne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYIZDne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 23:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbYIZDnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 23:43:25 -0400
Received: from smtp101.prem.mail.sp1.yahoo.com ([98.136.44.56]:48447 "HELO
	smtp101.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753041AbYIZDnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 23:43:24 -0400
X-YMail-OSG: oslkn5MVM1lDp4xfygwvmtqtzYkgXjLEVa5PA4oTHGzcTETdNuNpjrwoZGijaFEZWSKqiv.DkYwJ1e2np88WQJ124bqnYn51Sdui2fNKUXxwG4_et85wGT53qOiclV.jYrjYiVbgXMnW7Jq9KjdzKagb2McIaaAAyKoIb59mWKOiMRXsKw--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <48DC5A45.8020801@schaufler-ca.com>
Date: Thu, 25 Sep 2008 20:43:01 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Tilman Baumann <tilman.baumann@collax.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: SMACK netfilter smacklabel socket match
References: <48DBC9A1.20900@collax.com>
In-Reply-To: <48DBC9A1.20900@collax.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Baumann wrote:
> Hi all,
>
> i made some SMACK related patches. I hope this list is the right place 
> to post them.

Here and, probably more importantly 
linux-security-module@vger.kernel.org as that's
my primary hang out.

> The intention behind this patch is that i needed a way to (firewall) 
> match for packets originating from specific processes.
> The existing owner match did not work well enough, especially since 
> the cmd-owner part is removed.
> Then i thought about a way to tag processes and somehow match this tag 
> in the firewall.
> I recalled that SELinux can do this (SECMARK) but SELinux would have 
> been way to complex for what i want. But the idea was born, i just 
> needed something more simple.
>
> SMACK seemed to be the right way. So i made a little primitive 
> netfilter match to match against the security context of sockets.
> SMACK does CIPSO labels, but this was not what i wanted, i wanted to 
> label the socket not the packet (on the wire).
> This of course only works for packets with a local socket, but this 
> was my intention anyway.
>
> This way i can label a process and all it's sockets carry the same 
> label which i then can use to match against in the firewall.
>

Hmm. It looks as if your code will do what you're asking it to do.
Are you going to be happy with the access restrictions that will be
imposed by Smack?

> The code is pretty much based on cargo cult coding from other 
> netfilter matches, especially the owner match (which turned out to be 
> a bad reference since it is crapped with tons of compat interfaces).
>
> I have no kernel coding experience whatsoever and little C coding 
> history. So i would really like you guys to look over it a bit.
>
> Originally i intended to put this mask in the xtables_match structure.
> .hooks = (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_LOCAL_IN)
> But it turned out that i then could not longer put the rule in a chain 
> which is called by the OUTPUT chain but only in OUTPUT directly.
> I did not investigate much more since i did not really understand this 
> part. Allowing the user to add this match wherever he wants to does 
> not hurt, if there is no local socket there is no matching.
> But maybe this is something that should be changed.
>
> About the Files:
> SMACK-netfilter-socket-label-match.patch
> is a git patch for the current kernel.
>
> iptables-smacklabel.patch
> contains the iptables userspace part (applies to iptables-1.4.1.1)
>
>
> Regards
>  Tilman Baumann

