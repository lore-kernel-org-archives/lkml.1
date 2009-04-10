Return-Path: <linux-kernel-owner+w=401wt.eu-S1763453AbZDJOES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763453AbZDJOES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 10:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbZDJOD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 10:03:58 -0400
Received: from LION.seas.upenn.edu ([158.130.12.194]:40400 "EHLO
	lion.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbZDJOD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 10:03:58 -0400
Message-ID: <49DF51B7.4070009@seas.upenn.edu>
Date: Fri, 10 Apr 2009 10:03:35 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=C9ric_Piel?= <E.A.B.Piel@tudelft.nl>
CC: Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Additional keys for dell-wmi
References: <200904082116.n38LG4Df012420@ampersand.seas.upenn.edu> <20090409153203.GB17194@srcf.ucam.org> <49DF26EB.4040106@tudelft.nl>
In-Reply-To: <49DF26EB.4040106@tudelft.nl>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Éric Piel wrote:
> Matthew Garrett schreef:
>> On Wed, Apr 08, 2009 at 05:16:04PM -0400, Rafi Rubin wrote:
>>
>>>  static struct key_entry dell_wmi_keymap[] = {
>>>  	{KE_KEY, 0xe045, KEY_PROG1},
>>> +	{KE_KEY, 0xe046, KEY_PROG2},
>>> +	{KE_KEY, 0xe047, KEY_PROG3},
>> Would this make more sense as a switch? That way userspace can know what 
>> state the screen is in.
>>
> Indeed, that seems more logical. And in addition, there is a switch
> called SW_TABLET_MODE, which would fit perfectly.
> I guess at initialisation you can consider it is in standard mode, and
> actually sort out the real state on the first event received.
> 
> Eric

Yeah, I noticed SW_TABLET_MODE after Matthew suggested using the switch and have been trying to
figure out how to use it?  Forgive my ignorance here, I've never knowingly used an ev switch, any
suggestions about how to monitor and check the state?  I don't see anything come out of the input
event node.

Anyway, even if we use a switch, is there any particular reason not to send a key stroke down to the
event device as well?  In my case I already had window manager based hotkeys setup to handle the
"rotate screen" button (that is actually a button).  And by sending the events as key strokes, its
very easy to catch and handle, and the action just goes to the active console, which I consider
desirable.

I tend to prefer mechanism that don't require extra convolutions and daemons to handle things like
this.  For example I've helped setup a thinkpad where the prevailing solution was to catch the hinge
rotation with acpid which pushes a message through dbus which is captured by a daemon the user runs
as part of their X session.  Needless to say that's a bit more of a pain and a bit more sensitive to
change in the winds.

Rafi
