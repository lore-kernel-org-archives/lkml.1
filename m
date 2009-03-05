Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZCERnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZCERnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 12:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbZCERmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 12:42:51 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:64654 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbZCERmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 12:42:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b/GLivUCGTIWY3p/Elptp5A4lwhrSLHJdpB83CKhqbu/LBJx3UO4Kef2I7SM0eIQPz
         VigjwlfsqOpA03gYRCg1T725VXL+fl3g2fRD7GOY20jo2mCz7U1P7Hy/46IaS9ObvWtm
         9HEtqkquniETOsF3BDlhrhH0LOU+DRR7E400c=
MIME-Version: 1.0
In-Reply-To: <49AFF0D7.8080007@oracle.com>
References: <dd18b0c30903042141k1adc0f6cj4bc286cfa29f475c@mail.gmail.com>
	 <20090305060436.GA5359@nowhere>
	 <dd18b0c30903042351oae6fafck255d6b1058c83f1f@mail.gmail.com>
	 <dd18b0c30903050046v4fc9eff3h99734406112ec0f1@mail.gmail.com>
	 <dd18b0c30903050049g68073bcamce13b9a2605372ba@mail.gmail.com>
	 <49AFF0D7.8080007@oracle.com>
Date: Thu, 5 Mar 2009 09:42:48 -0800
Message-ID: <dd18b0c30903050942w362a82d8pb9a945e7fb3ccad8@mail.gmail.com>
Subject: Re: [PATCH 1/1] unifdef.c change "getline" to "get_line" to avoid C 
	library confusion.
From: Justin Mattock <justinmattock@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 5, 2009 at 7:33 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> From: Justin P. Mattock <justinmattock@gmail.com>
>> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>>
>> This fixes an error when compiling the kernel.
>
> Did you determine why you need this now and other people don't
> need it (yet)?  Maybe the rest of us will need it in the future...
>
>
>>  CHK     include/linux/version.h
>>  HOSTCC  scripts/unifdef
>> scripts/unifdef.c:209: error: conflicting types for 'getline'
>> /usr/include/stdio.h:651: note: previous declaration of 'getline' was here
>> make[1]: *** [scripts/unifdef] Error 1
>> make: *** [__headers] Error 2
>>
>> --
>> scripts/unifdef.c  |  3 +++
>> 1 files changed, 3 insertions(+),0 deletions(-)
>>
>> ---a/scripts/unifdef.c                2009-03-05 00:07:28.000000000 -0800
>> +++b/scripts/unifdef.c        2009-03-05 00:04:56.000000000 -0800
>> @@ -206,7 +206,7 @@ static void             done(void);
>>  static void             error(const char *);
>>  static int              findsym(const char *);
>>  static void             flushline(bool);
>> -static Linetype         getline(void);
>> +static Linetype         get_line(void);
>>  static Linetype         ifeval(const char **);
>>  static void             ignoreoff(void);
>>  static void             ignoreon(void);
>> @@ -512,7 +512,7 @@ process(void)
>>
>>       for (;;) {
>>               linenum++;
>> -             lineval = getline();
>> +             lineval = get_line();
>>               trans_table[ifstate[depth]][lineval]();
>>               debug("process %s -> %s depth %d",
>>                   linetype_name[lineval],
>> @@ -526,7 +526,7 @@ process(void)
>>   * help from skipcomment().
>>   */
>>  static Linetype
>> -getline(void)
>> +get_line(void)
>>  {
>>       const char *cp;
>>       int cursym;
>>
>>
>
>
> --
> ~Randy
>

As for why I need this:
I keep getting an error while compiling the latest kernel.
(changing getline to get_line fixes it from here);

As for others needing this:
probably in the category for future use.
especially if people don't upgrade there kernel
and libc.

In speculation though, people may never hit this.
The setup I did was created an LFS system(always wanted to create a
linux system from source).
While creating this starting with a plain directory,
then compiling make, gcc, libc, making sure to set CFLAGS,
(in accordance to the processor)
then after those were complete, set the same
CFLAGS for every lib/app that I compiled and put into the system.
(this way the system is atomically synchronized with the processor);
Thus changing the whole setup that I have.
But then If this was the case I would of hit this probably earlier
with 2.6.29-rc4/5.


In regards to the patch(to make things correct) what or how do I
label this person in the patch so they get the proper credit:
vapier@gentoo.org
They were responsible with providing the change
of getline to get_line.
should it be:
Critical-info-by: Mike Frysinger  <vapier@gentoo.org>

And also adding the people who reviewed the patch.
This way the patch is proper irregardless of the patch making it
or not.

regards;


-- 
Justin P. Mattock
