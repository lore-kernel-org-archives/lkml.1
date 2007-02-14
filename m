Return-Path: <linux-kernel-owner+w=401wt.eu-S1751509AbXBNJsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbXBNJsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 04:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbXBNJsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 04:48:31 -0500
Received: from fed1rmmtao105.cox.net ([68.230.241.41]:55143 "EHLO
	fed1rmmtao105.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbXBNJsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 04:48:30 -0500
From: Junio C Hamano <junkio@cox.net>
To: Andy Parkins <andyparkins@gmail.com>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.0
References: <7vlkj1v3av.fsf@assigned-by-dhcp.cox.net>
	<200702140906.37440.andyparkins@gmail.com>
	<7vabzht72l.fsf@assigned-by-dhcp.cox.net>
Date: Wed, 14 Feb 2007 01:48:28 -0800
In-Reply-To: <7vabzht72l.fsf@assigned-by-dhcp.cox.net> (Junio C. Hamano's
	message of "Wed, 14 Feb 2007 01:35:46 -0800")
Message-ID: <7vzm7hrrwz.fsf@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano <junkio@cox.net> writes:

> Andy Parkins <andyparkins@gmail.com> writes:
>
>> On Wednesday 2007 February 14 03:14, Junio C Hamano wrote:
>>
>>>  - There is a configuration variable core.legacyheaders that
>>
>>> The above two are not enabled by default and you explicitly have
>>> to ask for them, because these two features make repositories
>>
>> It isn't really the case that you have to _enable_ legacyheaders?  It defaults 
>> to on already.  You actually have to disable legacyheaders.
>
> Ah, true.  What it should have stressed is that we currently
> default to the safer, backward compatible behaviour, and you have
> to explicitly ask to use more efficient but incompatible
> encoding by setting core.legacyheaders to false.

So this will be the updated explanation.

-- >8 --
diff --git a/Documentation/RelNotes-1.5.0.txt b/Documentation/RelNotes-1.5.0.txt
index f0120e1..0989ded 100644
--- a/Documentation/RelNotes-1.5.0.txt
+++ b/Documentation/RelNotes-1.5.0.txt
@@ -25,12 +25,18 @@ Specifically, the available options are:
    older clients over dumb transports (e.g. http) using older
    versions of git will also be affected.
 
+   To let git use the new loose object format, you have to
+   set core.legacyheaders to false.
+
  - Since v1.4.3, configuration repack.usedeltabaseoffset allows
    packfile to be created in more space efficient format, which
    cannot be read by git older than that version.
 
-The above two are not enabled by default and you explicitly have
-to ask for them, because these two features make repositories
+   To let git use the new format for packfiles, you have to
+   set repack.usedeltabaseoffset to true.
+
+The above two new features are not enabled by default and you
+have explicitly to ask for them, because they make repositories
 unreadable by older versions of git, and in v1.5.0 we still do
 not enable them by default for the same reason.  We will change
 this default probably 1 year after 1.4.2's release, when it is

