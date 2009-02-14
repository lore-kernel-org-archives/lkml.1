Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbZBNAe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbZBNAe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 19:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZBNAeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 19:34:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37620 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbZBNAeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 19:34:18 -0500
Message-ID: <49961178.6040101@zytor.com>
Date: Fri, 13 Feb 2009 16:34:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/6] x86 tip asm ENTRY,ENDPROC cleanup
References: <20090213215017.959278111@gmail.com> <1234567411.13034.1300286953@webmail.messagingengine.com>
In-Reply-To: <1234567411.13034.1300286953@webmail.messagingengine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> 
> Hi Cyrill,
> 
> I like this direction. If I understand correctly:
> 
> ENTRY/END or GLOBAL/END for data.
> ENTRY/ENDPROC or GLOBAL/ENDPROC for functions.
> 

Fine for functions, but it's really not okay to use the same macros for 
data.  Furthermore, we need to consider special entry points that don't 
behave like normal functions -- like system call or interrupt entry.

Why?  Because if we're compiling with frame pointers, we would like the 
wrapper macros for functions to handle setting up and tearing down the 
frame pointer, at least in the common case.

	-hpa
