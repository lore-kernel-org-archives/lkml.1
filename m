Return-Path: <linux-kernel-owner+w=401wt.eu-S1764097AbYEGVEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764097AbYEGVEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbYEGVEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:04:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577AbYEGVEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:04:23 -0400
Date: Wed, 7 May 2008 14:03:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: JosephChan@via.com.tw, geert@linux-m68k.org,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 1/9] viafb: VIA Frame Buffer Device
 Driver - Resend
Message-Id: <20080507140357.9320dfcd.akpm@linux-foundation.org>
In-Reply-To: <20080507184333.7d0f1bf4.krzysztof.h1@poczta.fm>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67745@exchtp03.taipei.via.com.tw>
	<20080507184333.7d0f1bf4.krzysztof.h1@poczta.fm>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008 18:43:33 +0200
Krzysztof Helt <krzysztof.h1@poczta.fm> wrote:

> A general comment is that you use to many global variables.

yes, that was my first impression.  The _names_ of those variables is a
real problem.  lcd_mode, DeviceStatus, second_size, primary_dev, etc.  The
driver is attempting to reserve all those names for itself, kernel-wide.

So at a minimum, going through and prepending viafb_ onto all those would
be needed.


There are a number of layout glitches in there.  Such as a strange combination of
two styles:

void foo(void)
{

versus

void foo(void ) {

Many of these things can be pinpointed by processing the diff with
scripts/checkpatch.pl.


Administrative note: all nine patches had the same title "viafb: VIA Frame
Buffer Device Driver".  Please choose unique and meaningful names for each
patch, such as "viafb: add utility header file".


Apart from those fairly easily-fixed things, the driver looks pretty good
from a quick scan, given how large it is, and given that it probably has
been around for quite a long time..

