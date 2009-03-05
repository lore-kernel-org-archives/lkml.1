Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZCEIuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZCEIuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 03:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbZCEItw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 03:49:52 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:10242 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbZCEItv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 03:49:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PoeQdNJQjkU9aUNfee2I9Mir8xrZWkCAbgKWXTFS/fSNdBNh/TemaellOROXSwShi6
         txI8R2pddGTZ+pljU1mDM+2ADaNdO4ZS7oV22iQTT+mwqG3Q+DhdZgr0KFqH+fJnoyK0
         tE+X8ars9Rs5Ojs/HjXbAm3HwEcJAuC3G8crg=
MIME-Version: 1.0
In-Reply-To: <dd18b0c30903050046v4fc9eff3h99734406112ec0f1@mail.gmail.com>
References: <dd18b0c30903042141k1adc0f6cj4bc286cfa29f475c@mail.gmail.com>
	 <20090305060436.GA5359@nowhere>
	 <dd18b0c30903042351oae6fafck255d6b1058c83f1f@mail.gmail.com>
	 <dd18b0c30903050046v4fc9eff3h99734406112ec0f1@mail.gmail.com>
Date: Thu, 5 Mar 2009 00:49:49 -0800
Message-ID: <dd18b0c30903050049g68073bcamce13b9a2605372ba@mail.gmail.com>
Subject: Re: [PATCH 1/1] unifdef.c change "getline" to "get_line" to avoid C 
	library confusion.
From: Justin Mattock <justinmattock@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 5, 2009 at 12:46 AM, Justin Mattock <justinmattock@gmail.com> wrote:
> On Wed, Mar 4, 2009 at 11:51 PM, Justin Mattock <justinmattock@gmail.com> wrote:
>> On Wed, Mar 4, 2009 at 10:04 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>> On Wed, Mar 04, 2009 at 09:41:09PM -0800, Justin Mattock wrote:
>>>> From: Justin P. Mattock <justinmattock@gmail.com>
>>>>
>>>> This fixes an error when compiling the kernel.
>>>>
>>>>   CHK     include/linux/version.h
>>>>   HOSTCC  scripts/unifdef
>>>> scripts/unifdef.c:209: error: conflicting types for 'getline'
>>>> /usr/include/stdio.h:651: note: previous declaration of 'getline' was here
>>>> make[1]: *** [scripts/unifdef] Error 1
>>>> make: *** [__headers] Error 2
>>>>
>>>> --
>>>> scripts/unifdef.c  |  3 +++
>>>> 1 files changed, 3 insertions(+),0 deletions(-)
>>>>
>>>> diff --git a/scripts/unifdef.c b/scripts/unifdef.c
>>>> ---a/scripts/unifdef.c
>>>> +++b/scripts/unifdef.c
>>>> @@ -203,1 +203,0 @@ static void             addsym(bool, bool, char *);
>>>>
>>>>
>>>> static void             done(void);
>>>> static void             error(const char *);
>>>> static int              findsym(const char *);
>>>> static void             flushline(bool);
>>>> -static Linetype         getline(void);
>>>> +static Linetype         get_line(void);
>>>> static Linetype         ifeval(const char **);
>>>> static void             ignoreoff(void);
>>>> static void             ignoreon(void);
>>>> static void             keywordedit(const char *);
>>>>
>>>>
>>>>
>>>>
>>>> @@ -509,1 +509,0 @@ process(void)
>>>>
>>>>
>>>> {
>>>>       Linetype lineval;
>>>>
>>>>       for (;;) {
>>>>               linenum++;
>>>> -               lineval = getline();
>>>> +             lineval = get_line();
>>>>               trans_table[ifstate[depth]][lineval]();
>>>>               debug("process %s -> %s depth %d",
>>>>                   linetype_name[lineval],
>>>>                   ifstate_name[ifstate[depth]], depth);
>>>>       }
>>>> }
>>>>
>>>>
>>>> @@ -528,1 +528,0 @@ static Linetype
>>>> -getline(void)
>>>> +get_line(void)
>>>> {
>>>>       const char *cp;
>>>>
>>>> --
>>>>
>>>>
>>>> keep in mind I've never created a patch before,
>>>> (so go easy on me);
>>>
>>>
>>> Hi,
>>>
>>> You forgot to put your Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>>> :)
>>>
>>> See Documentation/SubmittingPatches
>>>
>>> I don't know who is the maintainer of this file.
>>> Adding Andrew in Cc.
>>>
>>>
>>>> regards;
>>>>
>>>> --
>>>> Justin P. Mattock
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>>
>>
>> Cool,
>> thanks for the help.
>> I'll look at the doc's and google
>> as much as possible, so I get this
>> correct.
>>
>> regards;
>>
>> --
>> Justin P. Mattock
>>
>
> O.K. after doing some reading,
> I have a better idea of how to make a
> patch. I used diff, used patch -Np1, and compiled.
> and added the signed off part.
> I'll post after this post.
> and take any suggestions on what to do next.
>
> --
> Justin P. Mattock
>


From: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

This fixes an error when compiling the kernel.

 CHK     include/linux/version.h
 HOSTCC  scripts/unifdef
scripts/unifdef.c:209: error: conflicting types for 'getline'
/usr/include/stdio.h:651: note: previous declaration of 'getline' was here
make[1]: *** [scripts/unifdef] Error 1
make: *** [__headers] Error 2

--
scripts/unifdef.c  |  3 +++
1 files changed, 3 insertions(+),0 deletions(-)

---a/scripts/unifdef.c	        2009-03-05 00:07:28.000000000 -0800
+++b/scripts/unifdef.c	2009-03-05 00:04:56.000000000 -0800
@@ -206,7 +206,7 @@ static void             done(void);
 static void             error(const char *);
 static int              findsym(const char *);
 static void             flushline(bool);
-static Linetype         getline(void);
+static Linetype         get_line(void);
 static Linetype         ifeval(const char **);
 static void             ignoreoff(void);
 static void             ignoreon(void);
@@ -512,7 +512,7 @@ process(void)

 	for (;;) {
 		linenum++;
-		lineval = getline();
+		lineval = get_line();
 		trans_table[ifstate[depth]][lineval]();
 		debug("process %s -> %s depth %d",
 		    linetype_name[lineval],
@@ -526,7 +526,7 @@ process(void)
  * help from skipcomment().
  */
 static Linetype
-getline(void)
+get_line(void)
 {
 	const char *cp;
 	int cursym;


-- 
Justin P. Mattock
