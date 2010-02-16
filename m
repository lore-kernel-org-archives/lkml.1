Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275Ab0BPT5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 14:57:51 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:41385 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756767Ab0BPT5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 14:57:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5I0RJhqHhJYPgcsJCJytRajSAsNbqU5YsQsWokw7/OjerBZGHhv0NjraLqWlPh60BSIckNBGjPRiaiqmHJcLpskGvxjY7UujFcZobR/hctcO1WuG2+oyuzDs9VNQgx2Vc0llu/CYKtwsqC+Vdawt4xdlOFZeSVRqXsc1E2OGAZU=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: ctM4nSsVM1mYf3AXJWS4LurM5.GmTiLpWr6De5U6WxZSy6NgBvLjff5uu6AB4cA6DKiF3JuRveJDUz15FgFXfG.WtdaTpz_6PP4ddOQavJYeq3fVnD1u9ziJ9vVi2N9ksbwCkuPRXroF4kS36DyQiEZ_iNULueysVw2CksT.cbF_.CblBHvG64_ssAIhnwFIJ8om7ZvFHlV0LJ6aAv9BD5cZgfwAxdp4cAzws4_deSOeIyvJVqANw2espqXDcMeS
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Denis Turischev <denis@compulab.co.il>
Subject: Re: [PATCH 1/3] MFD: introduce lpc_sch for Intel SCH LPC bridge
Date: Tue, 16 Feb 2010 11:57:46 -0800
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
       Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org
References: <4B73DAEE.5080400@compulab.co.il> <4B73DB4B.40501@compulab.co.il>
In-Reply-To: <4B73DB4B.40501@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002161157.47196.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 February 2010, Denis Turischev wrote:
> Intel Poulsbo (SCH) chipset LPC bridge controller contains several
> functions. Creating and MFD driver for the LPC bridge controller allows

Spelling nit: "Creating an" (not and).  Keyboard, brain, or edit fault.  ;)


> simultaneous use of SMBus and GPIO interfaces on the SCH.

This looks like the right way to package such southbridge level
componentry.  Maye not just these two interfaces, either.

But ... how does this play with ACPI?  The last several Intel
systems I looked at seemed to expect ACPI to manage GPIOs and the
IRQs they may issue.  (He wrote, staring at an ICH8-system where
ACPI uses GPIOs to manage several buttons and LEDs.)

It would seem error-prone to ignore that coupling on systems
with ACPI.  Linux has enough trouble sorting out issues caused
by buggy AML (ACPI bytecode) without introducing conflicts in
who manages which hardware resource (ACPI vs. operating system).

Of course, if ACPI weren't being used to hide such board-specific
details from operating systems, such issues would not exist.  But
such hiding is one of the basic goals of ACPI ... annoying.

