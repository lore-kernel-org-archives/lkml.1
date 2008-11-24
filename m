Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbYKXXOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbYKXXOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 18:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYKXXO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 18:14:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:11986 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbYKXXO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 18:14:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=pEk7/p0pIy09iMOP+O6RMe7RqBQbXG0/hY3LWg0YSSb9hWOU7zwrKuS58QjedEAE6b
         aEwMwulqHvxqqvWXarZfVidt3PW5ZA/DG7YDwZPBY4C7uLJVpmu1pWeOLUeloh+B3PKv
         nwdSHTtK6UV3+vteInrrjMgIfN134oLNuH0hE=
Message-ID: <cfd18e0f0811241514l121ecdb9l3e424f45df78e5b8@mail.gmail.com>
Date: Mon, 24 Nov 2008 18:14:24 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: CLONE_NEWUTS documentation
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
       "Kirill Korotaev" <dev@openvz.org>,
       "Herbert Poetzl" <herbert@13thfloor.at>, "Andrey Savochkin" <saw@sw.ru>,
       "Subrata Modak" <subrata@linux.vnet.ibm.com>
In-Reply-To: <20081123224708.GC12687@hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492464F8.8070101@gmail.com> <20081123224708.GC12687@hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Serge,

On Sun, Nov 23, 2008 at 5:47 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Michael Kerrisk (mtk.manpages@googlemail.com):
>> Serge, Eric,
>>
>> Below is a patch to document the CLONE_NEWUTS flag that was
>> added in 2.6.19.
>
> Thanks for writing this.

Thanks for replying ;-).

>> Could you please review and let me know of improvements
>> or inaccuracies?
>>
>> By the way, does anyone know where the UTS name in the uname()
>> API comes from? My best guess is that it's from Unix Timesharing
>> System, but I don't know this for sure.
>
> That sounds plausible - I've wondered myself and even googled a
> bit, but not found an answer.  I suppose we might need to ask
> Linus, or check one of the git repos that goes back to the early
> 90s and see who created the struct.

Oh -- "utsname" as a string (used in the uname() API) way predates Linux.

>> diff --git a/man2/clone.2 b/man2/clone.2
>> index 7212332..80f9caf 100644
>> --- a/man2/clone.2
>> +++ b/man2/clone.2
>> @@ -341,6 +340,33 @@ configuration option and that the process be privileged
>>  This flag can't be specified in conjunction with
>>  .BR CLONE_THREAD .
>>  .TP
>> +.BR CLONE_NEWUTS " (since Linux 2.6.19)"
>> +If
>> +.B CLONE_NEWUTS
>> +is set, then create the process in a new UTS namespace.
>
> And the new UTS namespace will initially be identical as the
> parent - same hostname and domainname.

Yes, it's a good idea to make that clear.  I've added some words to cover that.

>> +If this flag is not set, then (as with
>> +.BR fork (2)),
>> +the process is created in the same UTS namespace as
>> +the calling process.
>> +This flag is intended for the implementation of control groups.
>
> I'm not sure Eric was sufficiently clear - this flag is intended
> for the implementation of virtual server functionality and maybe
> checkpoint/restart (though I'm not sure any apps will care about
> being able to reset the hostname on restart :)
> It's not that you have to call it 'virtual server functionality',
> just that 'control groups' is definately not right.
>
> Maybe 'lightweight containers'?  "lightweight virtual servers'?

I just made it "containers".  Is that okay?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
