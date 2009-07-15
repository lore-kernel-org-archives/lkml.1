Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbZGOVdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbZGOVdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 17:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbZGOVdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 17:33:35 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:47128 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbZGOVdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 17:33:33 -0400
MIME-Version: 1.0
In-Reply-To: <20090715133627.GA2538@elf.ucw.cz>
References: <20090714100634.GA4054@elf.ucw.cz>
	 <5d5443650907140320w334864f4uc1ee13ed32fdb874@mail.gmail.com>
	 <20090715133627.GA2538@elf.ucw.cz>
Date: Wed, 15 Jul 2009 14:33:32 -0700
Message-ID: <d6200be20907151433q2f1ddc61m13c258c06ca4fd76@mail.gmail.com>
Subject: Re: Support for synaptic touchscreen in HTC dream
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Trilok Soni <soni.trilok@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, dmitry.torokhov@gmail.com,
       dtor@mail.ru, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 6:36 AM, Pavel Machek<pavel@ucw.cz> wrote:
> Hi!
>
>> > +static void decode_report(struct synaptics_ts_data *ts, u8 *buf)
>> > +{
>>
>> some documentation about this logic would be great.
>
> Arve, can you help here?

This sensor sends two 6-byte absolute finger reports, an optional
2-byte relative report followed by a status byte
(http://www.synaptics.com/sites/default/files/511_000099_01F.pdf).
This function reads the two finger reports and transforms the
coordinates according the platform data so they can be aligned with
the lcd behind the touchscreen. typically we flip the y-axis since the
sensor uses the bottom left corner as the origin, but if the sensor is
mounted upside down the platform data will request that the x-axis
should be flipped instead. The snap to inactive edge border are used
to allow tapping the edges of the screen on the G1. The active area of
the touchscreen is smaller than the lcd. When the finger gets close
the edge of the screen we snap it to the edge. This allows ui elements
at the edge of the screen to be hit, and it prevents hitting ui
elements that are not at the edge of the screen when the finger is
touching the edge.

-- 
Arve Hjønnevåg
