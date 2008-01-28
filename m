Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbYA1FKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbYA1FKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 00:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbYA1FKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 00:10:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54842 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750726AbYA1FKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 00:10:43 -0500
Date: Sun, 27 Jan 2008 21:10:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH] Rationalise ACPI backlight implementation
Message-Id: <20080127211013.1ddaa6a1.akpm@linux-foundation.org>
In-Reply-To: <20080128012549.GA24166@srcf.ucam.org>
References: <20071226020325.GA21099@srcf.ucam.org>
	<200801241644.49114.lenb@kernel.org>
	<20080126220045.b93db7c9.akpm@linux-foundation.org>
	<20080128012549.GA24166@srcf.ucam.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 01:25:50 +0000 Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Sat, Jan 26, 2008 at 10:00:45PM -0800, Andrew Morton wrote:
> > - Create a new /sys node with a new name which has the new semantics.
> 
> The semantics are the same as they always have been - values between 0 
> and max_brightness are valid values. If you've made assumptions about 
> what max_brightness is, then that's a bug in the userspace application 
> rather than a change in the semantics of the interface.
> 

WTH?  My (utterly comedic chase-crap-around-the-tree) brightness script
was:

(
0 sh -c "echo $1 > /proc/acpi/sony/brightness"
0 sh -c "echo $1 > /proc/acpi/sony/brightness_default"
0 sh -c "echo $1 > /sys/class/backlight/sony/brightness"
0 sh -c "echo $1 > /sys/class/backlight/thinkpad_screen/brightness"
) 2>/dev/null

And yes, I had an rc.local command which assumed that 7 (later 8) is max
brightness.

You cannot seriously tell me that if we are to change this range from 0-8
up to 0-100 then this is not a backwards-incompatible change in
semantics.

My /sys/class/backlight/ directory is presently empty.  Rather than trying
to find out why, I think I'll just collapse in laughter.

Guys, sort it out, please.

