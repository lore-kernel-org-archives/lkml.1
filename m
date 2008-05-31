Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbYEaNJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbYEaNJV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 09:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYEaNJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 09:09:06 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:15357 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbYEaNJE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 09:09:04 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH BUGFIX -rc4] Smack: Respect 'unlabeled' netlabel mode
Date: Sat, 31 May 2008 09:08:59 -0400
User-Agent: KMail/1.9.7
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080530233603.GA2994@ubuntu> <538684.41302.qm@web36603.mail.mud.yahoo.com> <20080531005826.GA6945@ubuntu>
In-Reply-To: <20080531005826.GA6945@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200805310909.00106.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I'm late to the party ...

On Friday 30 May 2008 8:58:26 pm Ahmed S. Darwish wrote:
> There are two possible solutions in my mind:
>
> - Using a predefined netlabel domain to denote to unlabeled packets.
>   Defect: May collide with a user chosen label and used to break
> security. Solution: Use a domain name that can't become a label
> (Hackery ?)

>From my understanding of Smack that is what the ambient label does 
currently.  Does this not work correctly for you?

> - I've tried first to use what was done before the 'Smack: unlabeled
> outgoing ambient packets' patch, which honored nltype=unlabeled, but
> ignored netlabel completely:
>   i.e.
>
>   int rc = 0;
>   if (secattr.flags != NETLBL_SECATTR_NONE)
>        rc = netlbl_sock_setattr(sk, &secattr);
>   return rc
>
>   Paul, would this be right from a netlabel perspective ?

Well, what are you trying to do (it isn't clear to me from the code 
snippet above)?  The netlbl_sock_setattr() function looks at the 
secattr->domain field and uses the value their to lookup the desired 
labeling protocol (currently either CIPSO or unlabeled) and then the 
NetLabel subsystem passes the socket and the secattr information onto 
the specific protocol handler where the secattr->attr information is 
used to assign on-the-wire labels to the socket.

-- 
paul moore
linux @ hp
