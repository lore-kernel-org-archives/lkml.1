Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbZKRRu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbZKRRu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757984AbZKRRu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:50:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757939AbZKRRu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:50:57 -0500
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: "Andrew G. Morgan" <morgan@kernel.org>
Subject: Re: drop SECURITY_FILE_CAPABILITIES?
Date: Wed, 18 Nov 2009 12:49:29 -0500
User-Agent: KMail/1.12.2 (Linux/2.6.30.9-96.fc11.x86_64; KDE/4.3.2; x86_64; ; )
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Kees Cook <kees.cook@canonical.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       George Wilson <gcwilson@us.ibm.com>, KaiGai Kohei <kaigai@kaigai.gr.jp>
References: <20091110140739.GA15534@us.ibm.com> <20091111001914.GA30470@us.ibm.com> <551280e50911180840v5c3f2945t253c709ba2d033b2@mail.gmail.com>
In-Reply-To: <551280e50911180840v5c3f2945t253c709ba2d033b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181249.29140.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 November 2009 11:40:13 am Andrew G. Morgan wrote:
> >> But back to detecting the capability version number...if I pass 0 as the
> >> version in the header, why can't the kernel just say oh you want the
> >> preferred version number, stuff it in the header, and return the syscall
> >> with success and not EINVAL?
> 
> This is so a library can understand that it doesn't understand the
> current ABI.

If user space is passing a NULL for the cap_user_data_t argument, user space 
has a pretty good idea that its not expecting actual capabilities to be filled 
in. My basic point is that there is no way to "correctly" use the capabilities 
API to determine what the preferred version is.


> For example, consider the case of some kernel of the
> future with a different ABI meeting an old library.

Right. Either user space checks version numbers to verify it knows what its 
doing and errors out, or it blindly tries to set capabilities and gets an 
error. Either way, if user space is *really* using the API to do work, it 
won't be passing NULL as the user data argument.

Maybe if version is set to 0 and NULL is being passed for arg 2 to getcap, 
that would be the secret handshake that lets the kernel know all I want is the 
preferred version number and nothing else since there is no data structure to 
fill in.


> The intention is for it to fail safe and not blunder on doing
> "security" related operations with an imperfect idea of the current
> kernel interface.
> 
> This is how libcap figures out it can work with the hosting kernel:

capget(0x20080522, 0, NULL)             = -1 EFAULT (Bad address)

Still an error.

-Steve
