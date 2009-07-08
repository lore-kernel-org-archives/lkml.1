Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbZGHLUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbZGHLUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbZGHLUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:20:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:39508 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbZGHLU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:20:28 -0400
Date: Wed, 8 Jul 2009 13:20:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, rjw@sisk.pl, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.30 leaking keys on console switch
In-Reply-To: <20090708065325.GE3309@dtor-d630.eng.vmware.com>
Message-ID: <alpine.LNX.2.00.0907081317000.27327@wotan.suse.de>
References: <87eiss7uhb.fsf@basil.nowhere.org> <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de> <20090708065325.GE3309@dtor-d630.eng.vmware.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, Dmitry Torokhov wrote:

> > > One new issue I see in 2.6.30 (I think I saw it in some rc*s) too is 
> > > that console switch often leaks the Fkey of the console switch into the 
> > > target console.
> > > 
> > > The symptome is that e.g. firefox if it was active and you're switching
> > > into X displays its help screen (F1 = help). It happens on non X 
> > > consoles too, but of course the symptoms are different here.
> > > 
> > > That's a regression against 2.6.29; I don't remember it in .29
> > > 
> > > Haven't investigated code.
> > 
> > Are you seeing with a specific keyboard type(s), or is this a general 
> > problem? Could you confirm whether it is specific either 
> > to PS2 or USB keyboards only, or it does happen for both?
> 
> Can't think of any input chnages in this timeftrame that would cause
> such effect. Maybe TTY changes?

For completness, Andi sent me the following evtest output off-list 
yesterday. The LeftAlt being autorepeated at time 1246964430.448470 is a 
little bit suspicious, as it is preceeded by release ... I don't see how 
this could be causing the behavior Andi is observing though.

I am not able to reproduce the problem myself.

Event: time 1246964411.828591, type 4 (Misc), code 4 (ScanCode), value 70028
Event: time 1246964411.828596, type 1 (Key), code 28 (Enter), value 0
Event: time 1246964411.828598, -------------- Report Sync ------------
Event: time 1246964412.260590, type 4 (Misc), code 4 (ScanCode), value 700e2
Event: time 1246964412.260594, type 1 (Key), code 56 (LeftAlt), value 1
Event: time 1246964412.260597, -------------- Report Sync ------------
Event: time 1246964412.512460, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964412.512462, -------------- Report Sync ------------
Event: time 1246964412.548460, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964412.548462, -------------- Report Sync ------------
Event: time 1246964412.584458, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964412.584460, -------------- Report Sync ------------
Event: time 1246964412.620458, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964412.620460, -------------- Report Sync ------------
Event: time 1246964412.656460, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964412.656461, -------------- Report Sync ------------
Event: time 1246964412.692458, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964412.692460, -------------- Report Sync ------------
Event: time 1246964412.728459, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964412.728461, -------------- Report Sync ------------
Event: time 1246964412.764458, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964412.764459, -------------- Report Sync ------------
Event: time 1246964412.800461, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964412.800463, -------------- Report Sync ------------
Event: time 1246964412.836457, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964412.836459, -------------- Report Sync ------------
Event: time 1246964412.872458, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964412.872460, -------------- Report Sync ------------
Event: time 1246964412.908459, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964412.908460, -------------- Report Sync ------------
Event: time 1246964412.944457, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964412.944459, -------------- Report Sync ------------
Event: time 1246964412.980458, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964412.980460, -------------- Report Sync ------------
Event: time 1246964412.996593, type 4 (Misc), code 4 (ScanCode), value 70040
Event: time 1246964412.996597, type 1 (Key), code 65 (F7), value 1
Event: time 1246964412.996599, -------------- Report Sync ------------
Event: time 1246964413.000467, type 17 (LED), code 0 (NumLock), value 0
Event: time 1246964413.000469, -------------- Report Sync ------------
Event: time 1246964413.156598, type 4 (Misc), code 4 (ScanCode), value 700e2
Event: time 1246964413.156604, type 1 (Key), code 56 (LeftAlt), value 0
Event: time 1246964413.156608, type 4 (Misc), code 4 (ScanCode), value 70040
Event: time 1246964413.156610, type 1 (Key), code 65 (F7), value 0
Event: time 1246964413.156611, -------------- Report Sync ------------
Event: time 1246964417.492588, type 4 (Misc), code 4 (ScanCode), value 700e2
Event: time 1246964417.492592, type 1 (Key), code 56 (LeftAlt), value 1
Event: time 1246964417.492595, -------------- Report Sync ------------
Event: time 1246964417.508611, type 17 (LED), code 0 (NumLock), value 1
Event: time 1246964417.508613, -------------- Report Sync ------------
Event: time 1246964417.668469, type 4 (Misc), code 4 (ScanCode), value 700e2
Event: time 1246964417.668475, type 1 (Key), code 56 (LeftAlt), value 0
Event: time 1246964417.668478, -------------- Report Sync ------------
Event: time 1246964417.988595, type 4 (Misc), code 4 (ScanCode), value 700e2
Event: time 1246964417.988602, type 1 (Key), code 56 (LeftAlt), value 1
Event: time 1246964417.988605, -------------- Report Sync ------------
Event: time 1246964418.240460, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964418.240463, -------------- Report Sync ------------
Event: time 1246964418.276459, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964418.276461, -------------- Report Sync ------------
Event: time 1246964418.312459, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964418.312461, -------------- Report Sync ------------
Event: time 1246964418.348457, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964418.348459, -------------- Report Sync ------------
Event: time 1246964418.384458, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964418.384460, -------------- Report Sync ------------
Event: time 1246964418.420459, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964418.420461, -------------- Report Sync ------------
Event: time 1246964418.456457, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964418.456459, -------------- Report Sync ------------
Event: time 1246964418.492457, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964418.492459, -------------- Report Sync ------------
Event: time 1246964418.528459, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964418.528461, -------------- Report Sync ------------
Event: time 1246964418.564459, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964418.564461, -------------- Report Sync ------------
Event: time 1246964418.564597, type 4 (Misc), code 4 (ScanCode), value 70040
Event: time 1246964418.564600, type 1 (Key), code 65 (F7), value 1
Event: time 1246964418.564602, -------------- Report Sync ------------
Event: time 1246964418.568467, type 17 (LED), code 0 (NumLock), value 0
Event: time 1246964418.568470, -------------- Report Sync ------------
Event: time 1246964418.724597, type 4 (Misc), code 4 (ScanCode), value 700e2
Event: time 1246964418.724602, type 1 (Key), code 56 (LeftAlt), value 0
Event: time 1246964418.724605, type 4 (Misc), code 4 (ScanCode), value 70040
Event: time 1246964418.724607, type 1 (Key), code 65 (F7), value 0
Event: time 1246964418.724609, -------------- Report Sync ------------
Event: time 1246964424.148592, type 4 (Misc), code 4 (ScanCode), value 700e2
Event: time 1246964424.148597, type 1 (Key), code 56 (LeftAlt), value 1
Event: time 1246964424.148600, -------------- Report Sync ------------
Event: time 1246964424.224609, type 17 (LED), code 0 (NumLock), value 1
Event: time 1246964424.224611, -------------- Report Sync ------------
Event: time 1246964424.388595, type 4 (Misc), code 4 (ScanCode), value 700e2
Event: time 1246964424.388601, type 1 (Key), code 56 (LeftAlt), value 0
Event: time 1246964424.388604, -------------- Report Sync ------------
Event: time 1246964424.644596, type 4 (Misc), code 4 (ScanCode), value 700e2
Event: time 1246964424.644603, type 1 (Key), code 56 (LeftAlt), value 1
Event: time 1246964424.644606, -------------- Report Sync ------------
Event: time 1246964424.896459, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964424.896461, -------------- Report Sync ------------
Event: time 1246964424.932457, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964424.932459, -------------- Report Sync ------------
Event: time 1246964424.968460, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964424.968461, -------------- Report Sync ------------
Event: time 1246964425.004459, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964425.004460, -------------- Report Sync ------------
Event: time 1246964425.040457, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964425.040459, -------------- Report Sync ------------
Event: time 1246964425.076459, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964425.076461, -------------- Report Sync ------------
Event: time 1246964425.112459, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964425.112461, -------------- Report Sync ------------
Event: time 1246964425.148458, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964425.148460, -------------- Report Sync ------------
Event: time 1246964425.172593, type 4 (Misc), code 4 (ScanCode), value 70040
Event: time 1246964425.172597, type 1 (Key), code 65 (F7), value 1
Event: time 1246964425.172599, -------------- Report Sync ------------
Event: time 1246964425.176466, type 17 (LED), code 0 (NumLock), value 0
Event: time 1246964425.176468, -------------- Report Sync ------------
Event: time 1246964425.332599, type 4 (Misc), code 4 (ScanCode), value 700e2
Event: time 1246964425.332605, type 1 (Key), code 56 (LeftAlt), value 0
Event: time 1246964425.332608, type 4 (Misc), code 4 (ScanCode), value 70040
Event: time 1246964425.332610, type 1 (Key), code 65 (F7), value 0
Event: time 1246964425.332611, -------------- Report Sync ------------
Event: time 1246964430.368609, type 17 (LED), code 0 (NumLock), value 1
Event: time 1246964430.368612, -------------- Report Sync ------------
Event: time 1246964430.448470, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964430.448474, -------------- Report Sync ------------
Event: time 1246964430.484465, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964430.484468, -------------- Report Sync ------------
Event: time 1246964430.520461, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964430.520464, -------------- Report Sync ------------
Event: time 1246964430.532595, type 4 (Misc), code 4 (ScanCode), value 700e2
Event: time 1246964430.532599, type 1 (Key), code 56 (LeftAlt), value 0
Event: time 1246964430.532602, -------------- Report Sync ------------
Event: time 1246964430.980597, type 4 (Misc), code 4 (ScanCode), value 700e0
Event: time 1246964430.980603, type 1 (Key), code 29 (LeftControl), value 1
Event: time 1246964430.980608, -------------- Report Sync ------------
Event: time 1246964431.012596, type 4 (Misc), code 4 (ScanCode), value 700e2
Event: time 1246964431.012602, type 1 (Key), code 56 (LeftAlt), value 1
Event: time 1246964431.012605, -------------- Report Sync ------------
Event: time 1246964431.264471, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964431.264476, -------------- Report Sync ------------
Event: time 1246964431.300471, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964431.300476, -------------- Report Sync ------------
Event: time 1246964431.336466, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964431.336470, -------------- Report Sync ------------
Event: time 1246964431.372485, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964431.372488, -------------- Report Sync ------------
Event: time 1246964431.408472, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964431.408476, -------------- Report Sync ------------
Event: time 1246964431.444467, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964431.444470, -------------- Report Sync ------------
Event: time 1246964431.480501, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964431.480505, -------------- Report Sync ------------
Event: time 1246964431.516461, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964431.516464, -------------- Report Sync ------------
Event: time 1246964431.552468, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964431.552473, -------------- Report Sync ------------
Event: time 1246964431.588480, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964431.588484, -------------- Report Sync ------------
Event: time 1246964431.624460, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964431.624463, -------------- Report Sync ------------
Event: time 1246964431.660458, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964431.660460, -------------- Report Sync ------------
Event: time 1246964431.696464, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964431.696467, -------------- Report Sync ------------
Event: time 1246964431.732458, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964431.732460, -------------- Report Sync ------------
Event: time 1246964431.768459, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964431.768461, -------------- Report Sync ------------
Event: time 1246964431.804458, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964431.804460, -------------- Report Sync ------------
Event: time 1246964431.828598, type 4 (Misc), code 4 (ScanCode), value 70040
Event: time 1246964431.828602, type 1 (Key), code 65 (F7), value 1
Event: time 1246964431.828604, -------------- Report Sync ------------
Event: time 1246964431.832468, type 17 (LED), code 0 (NumLock), value 0
Event: time 1246964431.832470, -------------- Report Sync ------------
Event: time 1246964431.988595, type 4 (Misc), code 4 (ScanCode), value 700e0
Event: time 1246964431.988601, type 1 (Key), code 29 (LeftControl), value 0
Event: time 1246964431.988603, type 4 (Misc), code 4 (ScanCode), value 700e2
Event: time 1246964431.988605, type 1 (Key), code 56 (LeftAlt), value 0
Event: time 1246964431.988608, type 4 (Misc), code 4 (ScanCode), value 70040
Event: time 1246964431.988610, type 1 (Key), code 65 (F7), value 0
Event: time 1246964431.988611, -------------- Report Sync ------------
Event: time 1246964440.800611, type 17 (LED), code 0 (NumLock), value 1
Event: time 1246964440.800614, -------------- Report Sync ------------
Event: time 1246964440.916463, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964440.916468, -------------- Report Sync ------------
Event: time 1246964440.952463, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964440.952465, -------------- Report Sync ------------
Event: time 1246964440.964469, type 4 (Misc), code 4 (ScanCode), value 700e2
Event: time 1246964440.964472, type 1 (Key), code 56 (LeftAlt), value 0
Event: time 1246964440.964475, -------------- Report Sync ------------
Event: time 1246964441.172596, type 4 (Misc), code 4 (ScanCode), value 700e2
Event: time 1246964441.172601, type 1 (Key), code 56 (LeftAlt), value 1
Event: time 1246964441.172605, -------------- Report Sync ------------
Event: time 1246964441.424461, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964441.424464, -------------- Report Sync ------------
Event: time 1246964441.460458, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964441.460460, -------------- Report Sync ------------
Event: time 1246964441.496457, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964441.496459, -------------- Report Sync ------------
Event: time 1246964441.532460, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964441.532462, -------------- Report Sync ------------
Event: time 1246964441.568467, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964441.568470, -------------- Report Sync ------------
Event: time 1246964441.604475, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964441.604480, -------------- Report Sync ------------
Event: time 1246964441.640465, type 1 (Key), code 56 (LeftAlt), value 2
Event: time 1246964441.640469, -------------- Report Sync ------------
Event: time 1246964441.652601, type 4 (Misc), code 4 (ScanCode), value 70040
Event: time 1246964441.652607, type 1 (Key), code 65 (F7), value 1
Event: time 1246964441.652609, -------------- Report Sync ------------
Event: time 1246964441.656468, type 17 (LED), code 0 (NumLock), value 0
Event: time 1246964441.656471, -------------- Report Sync ------------
Event: time 1246964441.812597, type 4 (Misc), code 4 (ScanCode), value 700e2
Event: time 1246964441.812603, type 1 (Key), code 56 (LeftAlt), value 0
Event: time 1246964441.812607, type 4 (Misc), code 4 (ScanCode), value 70040
Event: time 1246964441.812609, type 1 (Key), code 65 (F7), value 0
Event: time 1246964441.812610, -------------- Report Sync ------------
Event: time 1246964445.504609, type 17 (LED), code 0 (NumLock), value 1
Event: time 1246964445.504612, -------------- Report Sync ------------
Event: time 1246964446.452594, type 4 (Misc), code 4 (ScanCode), value 700e0
Event: time 1246964446.452600, type 1 (Key), code 29 (LeftControl), value 1
Event: time 1246964446.452603, -------------- Report Sync ------------

-- 
Jiri Kosina
SUSE Labs
