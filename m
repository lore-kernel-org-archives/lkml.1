Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbZBDSbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbZBDSbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbZBDSbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:31:01 -0500
Received: from fifo99.com ([67.223.236.141]:58526 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbZBDSbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:31:00 -0500
Subject: Re: [crash] af9005_usb_module_init(): BUG: unable to handle kernel
	paging request at ff100000
From: Daniel Walker <dwalker@fifo99.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
       Janne Grunau <janne-dvb@grunau.be>, Luca Olivetti <luca@ventoso.org>
In-Reply-To: <20090203172836.GA6964@elte.hu>
References: <20090203172836.GA6964@elte.hu>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 10:30:58 -0800
Message-Id: <1233772258.15119.106.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 18:28 +0100, Ingo Molnar wrote:
> 
> c23eca7a <af9005_usb_module_init>:
> c23eca7a:	55                   	push   %ebp
> c23eca7b:	89 e5                	mov    %esp,%ebp
> c23eca7d:	53                   	push   %ebx
> c23eca7e:	b9 2b 31 11 c2       	mov    $0xc211312b,%ecx
> c23eca83:	31 d2                	xor    %edx,%edx
> c23eca85:	b8 b8 b4 2b c2       	mov    $0xc22bb4b8,%eax
> c23eca8a:	e8 d6 e8 4e ff       	call   c18db365 <usb_register_driver>
> c23eca8f:	89 c3                	mov    %eax,%ebx
> c23eca91:	85 c0                	test   %eax,%eax
> c23eca93:	74 0f                	je     c23ecaa4 <af9005_usb_module_init+0x2a>
> c23eca95:	50                   	push   %eax
> c23eca96:	68 3a 31 11 c2       	push   $0xc211313a
> c23eca9b:	e8 70 49 c6 fe       	call   c1051410 <printk>
> c23ecaa0:	58                   	pop    %eax
> c23ecaa1:	5a                   	pop    %edx
> c23ecaa2:	eb 64                	jmp    c23ecb08 <af9005_usb_module_init+0x8e>
> c23ecaa4:	c7 05 8c 71 cd c2 00 	movl   $0x0,0xc2cd718c
> c23ecaab:	00 00 00 
> c23ecaae:	c7 05 90 71 cd c2 00 	movl   $0x0,0xc2cd7190
> c23ecab5:	00 00 00 
> c23ecab8:	c7 05 94 71 cd c2 00 	movl   $0x0,0xc2cd7194
> c23ecabf:	00 00 00 
> c23ecac2:	b8 00 00 00 00       	mov    $0x0,%eax
> c23ecac7:	85 c0                	test   %eax,%eax
> c23ecac9:	74 12                	je     c23ecadd <af9005_usb_module_init+0x63>
> c23ecacb:	b8 00 00 00 00       	mov    $0x0,%eax
> c23ecad0:	85 c0                	test   %eax,%eax
> c23ecad2:	74 09                	je     c23ecadd <af9005_usb_module_init+0x63>
> c23ecad4:	b8 00 00 00 00       	mov    $0x0,%eax
> c23ecad9:	85 c0                	test   %eax,%eax
> c23ecadb:	75 17                	jne    c23ecaf4 <af9005_usb_module_init+0x7a>
> c23ecadd:	68 60 31 11 c2       	push   $0xc2113160
> c23ecae2:	e8 29 49 c6 fe       	call   c1051410 <printk>
> c23ecae7:	c7 05 00 b6 2b c2 00 	movl   $0x0,0xc22bb600
> c23ecaee:	00 00 00 
> c23ecaf1:	58                   	pop    %eax
> c23ecaf2:	eb 14                	jmp    c23ecb08 <af9005_usb_module_init+0x8e>
> c23ecaf4:	c7 05 f8 b5 2b c2 00 	movl   $0x0,0xc22bb5f8
> c23ecafb:	00 00 00 
> c23ecafe:	a1 00 00 00 00       	mov    0x0,%eax           <= crash
> c23ecb03:	a3 fc b5 2b c2       	mov    %eax,0xc22bb5fc
> c23ecb08:	89 d8                	mov    %ebx,%eax
> c23ecb0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
> c23ecb0d:	c9                   	leave  
> c23ecb0e:	c3                   	ret    

Could this be a problem with your QA environment? (like distcc mixing
gcc versions) I'm not an assembly expert, but it looks like there are
several lines above that move zero into %eax , then test if %eax is
zero, and exit the function if it's zero.. for example line c23ecac2
which would jump over the crash line. I'm not sure how it's getting
there.

Daniel

