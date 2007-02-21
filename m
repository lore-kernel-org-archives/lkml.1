Return-Path: <linux-kernel-owner+w=401wt.eu-S1751283AbXBUO4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbXBUO4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 09:56:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbXBUO4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 09:56:07 -0500
Received: from lmv.inov.pt ([146.193.64.2]:36145 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbXBUO4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 09:56:06 -0500
Message-ID: <45DC5D57.4020507@inov.pt>
Date: Wed, 21 Feb 2007 14:55:19 +0000
From: Jose Goncalves <jose.goncalves@inov.pt>
User-Agent: Thunderbird 1.5.0.9 (X11/20070111)
MIME-Version: 1.0
To: Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
References: <20070220132909.GD566@slug> <20070219134539.GA27370@flint.arm.linux.org.uk> <20070220142442.GF566@slug> <20070219143520.GB27370@flint.arm.linux.org.uk> <20070220144814.GJ566@slug> <20070219150508.GD27370@flint.arm.linux.org.uk> <45D9D073.7020701@inov.pt> <20070219164200.GF27370@flint.arm.linux.org.uk> <45D9E46C.4030408@inov.pt> <20070219212347.GA4258@flint.arm.linux.org.uk> <45DC537B.6020108@inov.pt>
In-Reply-To: <45DC537B.6020108@inov.pt>
Content-Type: multipart/mixed;
 boundary="------------050504000408020008040006"
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050504000408020008040006
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Jose Goncalves wrote:
> New devolpments.
> I have upgraded to 2.6.16.41, applied a patch sent by Frederik that
> removed the changed made in http://lkml.org/lkml/2005/6/23/266 and
> activated some more kernel debug, i.e., CONFIG_KALLSYMS_ALL,
> CONFIG_DEBUG_KERNEL, CONFIG_DETECT_SOFTLOCKUP, CONFIG_DEBUG_SLAB,
> CONFIG_DEBUG_MUTEXES, CONFIG_FRAME_POINTER and CONFIG_FORCED_INLINING
> (thanks to vda for pointing me to the right doc.).
> At first it seemed to work fine, but after some days of continuous
> running I've got another kernel Oops!
> I attach the dmesg output and the assembly dump of serial8250_startup()
> and serial8250_shutdown().
>   

And also the assembly dump of serial_in() were the NULL pointer
dereference happens.

José Gonçalves


--------------050504000408020008040006
Content-Type: text/plain;
 name="objdump2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="objdump2.txt"


vmlinux-2.6.16.41-mtm5-debug1:     file format elf32-i386

Disassembly of section .text:

c01bfa70 <serial_in>:
c01bfa70:	55                   	push   %ebp
c01bfa71:	89 e5                	mov    %esp,%ebp
c01bfa73:	53                   	push   %ebx
c01bfa74:	8b 5d 08             	mov    0x8(%ebp),%ebx
c01bfa77:	8b 55 0c             	mov    0xc(%ebp),%edx
c01bfa7a:	0f b6 4b 12          	movzbl 0x12(%ebx),%ecx
c01bfa7e:	0f b6 43 13          	movzbl 0x13(%ebx),%eax
c01bfa82:	d3 e2                	shl    %cl,%edx
c01bfa84:	83 f8 02             	cmp    $0x2,%eax
c01bfa87:	74 1a                	je     c01bfaa3 <serial_in+0x33>
c01bfa89:	7f 05                	jg     c01bfa90 <serial_in+0x20>
c01bfa8b:	48                   	dec    %eax
c01bfa8c:	74 09                	je     c01bfa97 <serial_in+0x27>
c01bfa8e:	eb 21                	jmp    c01bfab1 <serial_in+0x41>
c01bfa90:	83 f8 03             	cmp    $0x3,%eax
c01bfa93:	74 15                	je     c01bfaaa <serial_in+0x3a>
c01bfa95:	eb 1a                	jmp    c01bfab1 <serial_in+0x41>
c01bfa97:	8a 43 78             	mov    0x78(%ebx),%al
c01bfa9a:	01 d0                	add    %edx,%eax
c01bfa9c:	8b 13                	mov    (%ebx),%edx
c01bfa9e:	48                   	dec    %eax
c01bfa9f:	ee                   	out    %al,(%dx)
c01bfaa0:	42                   	inc    %edx
c01bfaa1:	eb 10                	jmp    c01bfab3 <serial_in+0x43>
c01bfaa3:	03 53 04             	add    0x4(%ebx),%edx
c01bfaa6:	8a 02                	mov    (%edx),%al
c01bfaa8:	eb 0a                	jmp    c01bfab4 <serial_in+0x44>
c01bfaaa:	03 53 04             	add    0x4(%ebx),%edx
c01bfaad:	8b 02                	mov    (%edx),%eax
c01bfaaf:	eb 06                	jmp    c01bfab7 <serial_in+0x47>
c01bfab1:	03 13                	add    (%ebx),%edx
c01bfab3:	ec                   	in     (%dx),%al
c01bfab4:	0f b6 c0             	movzbl %al,%eax
c01bfab7:	5b                   	pop    %ebx
c01bfab8:	5d                   	pop    %ebp
c01bfab9:	c3                   	ret    
Disassembly of section .init.text:
Disassembly of section .altinstr_replacement:
Disassembly of section .exit.text:

--------------050504000408020008040006--
