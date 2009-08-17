Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbZHQQs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbZHQQs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 12:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbZHQQsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 12:48:55 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:44962 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbZHQQsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 12:48:54 -0400
MIME-Version: 1.0
In-Reply-To: <551280e50908170826o6f189354n4fd64a1cb601489f@mail.gmail.com>
References: <2359eed20908132115t2f6cea3by2429d54914d5ac6f@mail.gmail.com>
	 <20090814133225.GB27905@us.ibm.com>
	 <2359eed20908140840u2886b8dci4ce72914fc2b1ea9@mail.gmail.com>
	 <551280e50908151022tde71278gc0a745c52a8415ed@mail.gmail.com>
	 <2359eed20908152124s1af8d95eu7d4706ec3a50bc33@mail.gmail.com>
	 <551280e50908162150g3764d6caqf4de130befb7789f@mail.gmail.com>
	 <2359eed20908170738w4b3c5980x4e1defb2ed8e773c@mail.gmail.com>
	 <551280e50908170826o6f189354n4fd64a1cb601489f@mail.gmail.com>
Date: Mon, 17 Aug 2009 11:48:54 -0500
Message-ID: <2359eed20908170948p6612b075mc245aa4fb92e76aa@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/1] support optional non-VFS capability inheritance 
	without disabling file caps
From: Will Drewry <redpig@dataspill.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 10:26 AM, Andrew G. Morgan<morgan@kernel.org> wrote:
> On Mon, Aug 17, 2009 at 7:38 AM, Will Drewry<redpig@dataspill.org> wrote:
[snip]
>> It is almost possible to achieve #2 on existing systems, assuming xattr
>> support can always be achieved.
>> Step 1, setcap cap_sys_rawio+i /usr/bin/pulseaudio
>> Step 2, pam_cap at X11 login to add cap_sys_rawio+i for a user session
>> (alternately, use capsh).
>> Step 3, run pulseaudio (pP' = (...) | (fI & pI) => cap_sys_rawio+ip)
>
> What about filecaps of cap_sys_rawio+eip on pulseaudio. With the
> bounding set suppressing cap_sys_rawio?
>
> In this case, only a process with (pI & cap_sys_rawio) can exec()ute
> pulseaudio, let alone use the capability. That is, the filecap +pe
> implies that the capability is required for the app to run, but the
> bounding set suppresses the bit from the file's xattr...! The only way
> that the exec()d program can get this required bit is from the (pI &
> fI), and so only if a process has (pI & cap_sys_rawio) will it be able
> to invoke the program...

Aha! I was missing something.  I was thinking that the bounding set was
still governing system-wide despite the fact it was right in front of me
that it wasn't (kernel source, capsh).

This works perfectly and achieves the exact same goal of step-down root
permissions with run-time inheritance-based management.

I guess we can bin the patch since I doubt xattr-less filesystems are
worth the change. (I might whip up a stackable one just to avoid dealing
with symlinks and loopbacks :)

Thanks for working through this with me.  Sorry that it took a few
rounds.

cheers!
will
