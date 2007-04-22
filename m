Return-Path: <linux-kernel-owner+w=401wt.eu-S965680AbXDVTDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965680AbXDVTDl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 15:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965679AbXDVTDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 15:03:41 -0400
Received: from fed1rmmtao101.cox.net ([68.230.241.45]:57767 "EHLO
	fed1rmmtao101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965662AbXDVTDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 15:03:40 -0400
From: Junio C Hamano <junkio@cox.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Pitre <nico@cam.org>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Today's 'master' leaves .idx/.pack in 0400
References: <7vhcrml4wx.fsf@assigned-by-dhcp.cox.net>
	<7v1widrl0o.fsf@assigned-by-dhcp.cox.net>
	<alpine.LFD.0.98.0704221019100.9964@woody.linux-foundation.org>
	<7vvefonvdz.fsf@assigned-by-dhcp.cox.net>
	<7vmz10nv1h.fsf_-_@assigned-by-dhcp.cox.net>
	<alpine.LFD.0.98.0704221422250.28339@xanadu.home>
	<7vejmcnu28.fsf@assigned-by-dhcp.cox.net>
	<alpine.LFD.0.98.0704221431430.28339@xanadu.home>
	<alpine.LFD.0.98.0704221144250.9964@woody.linux-foundation.org>
Date: Sun, 22 Apr 2007 12:03:39 -0700
In-Reply-To: <alpine.LFD.0.98.0704221144250.9964@woody.linux-foundation.org>
	(Linus Torvalds's message of "Sun, 22 Apr 2007 11:54:41 -0700 (PDT)")
Message-ID: <7vy7kkmdtg.fsf@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sun, 22 Apr 2007, Nicolas Pitre wrote:
>> 
>> Well, actually there is no point making pack files writable.  If they're 
>> modified, they get corrupted.
>> 
>> Here's the fix I wanted to propose:
>> 
>> diff --git a/builtin-pack-objects.c b/builtin-pack-objects.c
>> index c72e07a..85c6e6e 100644
>> --- a/builtin-pack-objects.c
>> +++ b/builtin-pack-objects.c
>> @@ -1786,11 +1786,13 @@ int cmd_pack_objects(int argc, const char **argv, const char *prefix)
>>  		if (rename(pack_tmp_name, tmpname))
>>  			die("unable to rename temporary pack file: %s",
>>  			    strerror(errno));
>> +		chmod(tmpname, 0444);
>
> I think this is wrong (as is Junio's). I think we should still honor the 
> repository permission setting, and default to honoring umask.
>
> So I think that if the user has a umask that says "nobody else can read", 
> then we should *not* make it world readable (unless the 
> "shared_repository" thing is set to override it, of course).

I obviously agree, but as a tentative measure, I'll push out
0644 version anyway.

