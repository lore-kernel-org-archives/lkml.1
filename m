Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556Ab0ADQTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab0ADQTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428Ab0ADQS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:18:58 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:57039 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab0ADQS6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:18:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nF+Ntws3p4fawfYBSLYBIAFKC0FmqnVe/yXDKu+WaU1RDWcIhJfWEW0JyGvOVJiHjg
         YAs3DgHl02jnlpHVBau8wArQES6ssOmn6X5kmpt+HSeaFibORiHxvJy6L4IrPJO+0WBB
         6NrOpbay9a//y1MUCXuGXYlP6lyq1zmi8vZH8=
MIME-Version: 1.0
In-Reply-To: <c4e36d111001040747n2c9dbd52p1b9147ae186f3597@mail.gmail.com>
References: <c4e36d111001040747n2c9dbd52p1b9147ae186f3597@mail.gmail.com>
Date: Mon, 4 Jan 2010 17:18:53 +0100
Message-ID: <c4e36d111001040818i23f4a331y58412ab82c8b4e14@mail.gmail.com>
Subject: Re: Oops in uart_resume_port() on resume 2.6.32/33-rc
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: dsaxena@laptop.org, alan@linux.intel.com, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/4 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> Hi
>
> I wanted to trace some oops from i915 module via serial console log
> and instead I'm getting this oops from resume:
>
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000198
> IP: [<ffffffff812eee55>] uart_resume_port+0x1f5/0x270
> PGD 1396b6067 PUD 13baf4067 PMD 0
> Oops: 0000 [#1] PREEMPT SMP
> last sysfs file: /sys/power/state

> So I assume it is related to commit:
>
> ba15ab0e8de0d4439a91342ad52d55ca9e313f3d
>
> which adds access through  *state->port.tty->termios  without checking for NULL.
>

Small update - I've compiled current vanilla kernel
45d28b097280a78893ce25a5d0db41e6a2717853
(2.6.33-rc2-00268) just with reverted patch ba15ab0e8de0d and it works
and doesn't produce uart oops on resume - thought it's not probably
the right  fix - it is usable workaround for me...

Zdenek
