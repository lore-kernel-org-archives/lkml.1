Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690AbXJWE5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbXJWE5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 00:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbXJWE5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 00:57:15 -0400
Received: from namei.org ([69.55.235.186]:53067 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750891AbXJWE5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 00:57:14 -0400
Date: Tue, 23 Oct 2007 14:56:52 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Arjan van de Ven <arjan@infradead.org>
cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LSM conversion to static interface [revert patch]
In-Reply-To: <20071022210956.31f7bbcf@laptopd505.fenrus.org>
Message-ID: <Xine.LNX.4.64.0710231450450.31564@us.intercode.com.au>
References: <167451.96128.qm@web38607.mail.mud.yahoo.com>
 <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
 <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org>
 <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr>
 <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au>
 <20071022210956.31f7bbcf@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007, Arjan van de Ven wrote:

> @@ -4895,6 +4908,7 @@ static struct security_operations selinu
>  	.sem_semop =			selinux_sem_semop,
>  
>  	.register_security =		selinux_register_security,
> +	.unregister_security =		selinux_unregister_security,
>  
>  	.d_instantiate =                selinux_d_instantiate,

You also need to consider whether to allow capabilities to be built as an 
unloadable module.  If not, then we don't need this hook added back into 
SELinux.  Otherwise, if it is desired, you also need to reinstate 
capability_exit and general modular bits for security/capability.c.


- James
-- 
James Morris
<jmorris@namei.org>
