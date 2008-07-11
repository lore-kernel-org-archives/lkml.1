Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbYGKKcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbYGKKcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 06:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYGKKcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 06:32:04 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:18064 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbYGKKcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 06:32:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VGaMfPnms7A0SjOG4hxrtxCAKX/OURHlPp2/xNyO7xtKpahjobgG5h6y+d3CPN+0Ie
         VGaFaumi1K5z2RJKtUwEsQvSFnW5BhJiundKEf/sv07EXzTu7/wKzxWtrNDEfdpVKFM7
         uPx7cXP0YFYkkTerPF4cGMlSg9Liwkvc41ZqE=
Message-ID: <87a5b0800807110332y65ea8c15g2feaa8806b1f1d85@mail.gmail.com>
Date: Fri, 11 Jul 2008 11:32:01 +0100
From: "Will Newton" <will.newton@gmail.com>
To: "Luke -Jr" <luke@dashjr.org>
Subject: Re: kernel_entry up front
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200807102308.48706.luke@dashjr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807102308.48706.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 5:08 AM, Luke -Jr <luke@dashjr.org> wrote:
> I need to get kernel_entry to the lowest memory region in the binary. This is
> because a platform I am porting to does not support ELF, and always begins
> execution at the first word of the firmware image. Alternatively, if there is
> a simpler way to prepend the image with a jump to the kernel_entry symbol,
> that could work as well.

The easiest way to do this is to put your entry point in a named
section (for example .text.head) then edit vmlinux.lds.S to put that
section at the correct place in your kernel image.
