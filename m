Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbYGHOs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbYGHOs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 10:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbYGHOst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 10:48:49 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:46819 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbYGHOss convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 10:48:48 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: Pavel Machek <pavel@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Date: Tue, 8 Jul 2008 14:48:00 +0000
Subject: RE: [PATCH][resubmit] HP iLO driver
Thread-Topic: [PATCH][resubmit] HP iLO driver
Thread-Index: AcjgzYiI3XHCKmrHTF29vUSsDaYCKwAOBg8g
Message-ID: <CF70AA892F109448AEA269483B3A983903BB8CEFC4@G1W1215.americas.hpqcorp.net>
References: <20080623160052.GA7616@ldl.fc.hp.com>
 <20080627191458.GA10872@ucw.cz>
 <CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net>
 <20080707160658.GB1794@elf.ucw.cz>
 <CF70AA892F109448AEA269483B3A983903BB8CEA25@G1W1215.americas.hpqcorp.net>
 <20080708072152.GD1761@elf.ucw.cz> <20080708073818.GA14245@elf.ucw.cz>
In-Reply-To: <20080708073818.GA14245@elf.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> It probably does configure passwords on the management processor, for
> example?
>
> And for that functionality, something like
>
> echo new_password > /sys/hpilo/admin/password
>
> would make sense, right? Except that your interface is more like "echo
> ^%TEWFSGFSDF^%EW&^Tadmin^*&S^F&*SDYF*&SDYF*&YE*Wnew_password(*
> &DF&S^DF*&DS^F*&S
>> /dev/hpilo/d0ccb0", right? (And except that you consider exact
> string to echo to change password "proprietary secret").
>
> We'd like to have the first interface, but unfortunately we do not
> know enough about hpilo to even ask for better interface.

Is the first interface really preferrable?  How does that extend
to commands that need to return data?  Do we want to manage 30 different
commands in the kernel?  New functionality would require kernel updates.

It seems much cleaner to keep the kernel interface simple and opaque
(ie read/write), and handle the details of the commands in user space.
>From my limited understanding, I thought that was a common goal here:
move what you can to userspace.
