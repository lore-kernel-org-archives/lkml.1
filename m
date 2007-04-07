Return-Path: <linux-kernel-owner+w=401wt.eu-S966186AbXDGR0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966186AbXDGR0I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 13:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966188AbXDGR0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 13:26:08 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:35794 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966186AbXDGR0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 13:26:06 -0400
Date: Sat, 7 Apr 2007 19:26:03 +0200
From: Egmont Koblinger <egmont@uhulinux.hu>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
Message-ID: <20070407172603.GA25351@uhulinux.hu>
References: <20070406191245.GA11974@uhulinux.hu> <4616A2C7.3030000@zytor.com> <20070407092451.GA8779@uhulinux.hu> <Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2007 at 01:00:48PM +0200, Jan Engelhardt wrote:

Hi,

> Please, no dot, and no inverse color.
> Imagine someone had the following bitmap for <unknown glyph/illegal sequence>:

No dot, I'm already convinced. To clarify the inverse thingy:

This is what the current kernel does:
  1) tries to display the desired symbol
  2) if it fails, tries to display U+FFFD (which usually looks similar to an
     inverted question mark)
  3) if this fails again then displays a normal '?'
     (or a different symbol due to a bug discussed below)

Here's my proposal. This only alters the 3rd step, not the first two:
  1) tries to display the desired symbol
  2) if it fails, tries to display U+FFFD, still with _normal_ attributes
  3) if this fails then display an ascii '?' with inverted attributes

So you won't get "double" inversion. If you do have U+FFFD in your font then
this will introduce no chance. If you don't have U+FFFD, you'll see inverse
question marks instead of normal ones.


> I blame your latin2 unicode map. (See above about 'Û'.)

There's nothing wrong with my latin2 unicode map, and I've located and
changed the part _in the kernel_ that displays a false glyph using the
algorithm I've outlined. It just uses "the glyph at that code position
within the glyph table" as a fallback, which might be okay in 8-bit mode
(and I haven't modified the behavior in that case), but I got rid of this
behavior in UTF-8 mode since it's definitely a fault in the world of
Unicode.

> It should perhaps display a regular 'u' if it cannot display 'û',

I rather think it should display U+FFFD but YMMV.

> but definitely not 'ü' (which is not called a double accent, btw).

This is not the character I've been talking about, I actually _did_ talk
about u with double acute accent (ű - you might not have seen this character
so far, AFAIK it's only used in Hungarian, no other languages). But we agree
that the kernel definitely shouldn't display a character with a different
accent on it. This is one of the bugs my patch addresses.


bye,

Egmont
