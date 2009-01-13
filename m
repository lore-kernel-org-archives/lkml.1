Return-Path: <linux-kernel-owner+w=401wt.eu-S1761176AbZAMPAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761176AbZAMPAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 10:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbZAMPAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 10:00:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:42035 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbZAMPAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 10:00:21 -0500
Date: Tue, 13 Jan 2009 15:01:03 +0000
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, akpm@linux-foundation.org
Subject: [patch 0/2]  Improve the markup_oops.pl script
Message-ID: <20090113150103.085c6eb6@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the following 2 patches enhance the markup_oops.pl script in two ways
Patch 1: Add support for putting register values in the asm dump
Patch 2: Add support for 64 bit X86

The output (on a 32 bit OS with a "make me oops" example module) looks like
the pasted dump; for the instruction where the oops happened, as well as
a few instructions before that where the dumper can determine the register value.
the value is appended on said line.


 	if (bar-1) { 
 f8436012:	8b 45 fc             	mov    -0x4(%ebp),%eax 
 f8436015:	48                   	dec    %eax 
 f8436016:	74 09                	je     f8436021 <foo_bar+0x21> 
 		bar = bar * 5; 
 f8436018:	8b 45 fc             	mov    -0x4(%ebp),%eax 
 f843601b:	8d 04 80             	lea    (%eax,%eax,4),%eax  |  %eax => 0 
 f843601e:	89 45 fc             	mov    %eax,-0x4(%ebp)     |  %eax = 0 
 	} 
 	*foo = 1; 
*f8436021:	c6 02 01             	movb   $0x1,(%edx)         |  %edx = 0 <--- faulting instruction
 	return bar; 
 f8436024:	8b 45 fc             	mov    -0x4(%ebp),%eax 
 } 
 f8436027:	c9                   	leave   
 f8436028:	c3                   	ret     
  
--
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
