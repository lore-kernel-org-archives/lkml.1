Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018Ab0A0Q27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab0A0Q27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546Ab0A0Q25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:28:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53465 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab0A0Q24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:28:56 -0500
Message-ID: <4B6069A7.1020907@zytor.com>
Date: Wed, 27 Jan 2010 08:28:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86-64: Use normal ptregs stub for execve
References: <1264434453-2204-1-git-send-email-brgerst@gmail.com>	 <tip-f19a25c872b20ae4357f72687cf3e7b0da220ee2@git.kernel.org>	 <20100127130716.GA26908@elte.hu> <73c1f2161001270721x3d07b507lb78fa8c53567dcaa@mail.gmail.com>
In-Reply-To: <73c1f2161001270721x3d07b507lb78fa8c53567dcaa@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 07:21 AM, Brian Gerst wrote:
> 
> I see what is going on.  Grub is a 32-bit statically linked executable
> even on a 64-bit distro.  The old execve stub forced return to
> userspace via iret, but PTREGSCALL apparently doesn't.  This means
> that the 32-bit %cs isn't getting set.  Drop this patch for now.
> 

OK, I presume that breaks execing any 32-bit app, not just statically
linked (eww...)

Yet one more case of Grub making me shudder, though :-/

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

