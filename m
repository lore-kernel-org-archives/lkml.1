Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab0CEHU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 02:20:57 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:61389 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab0CEHUy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 02:20:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CEQAZubgp4S9cPi8gXoAmDZit2WpYTL7dkuNlbeKZhwCITTm8D/JIgvvfKxNfsShR4
         6RUP9sd4Ob/VY76kVhh7ncEsY6wZmJd5k+I8dyH9uDeG2Jrj74Lq7tRFrvA9F92i2Lec
         2iPe3US5wkuEDAhPBpPWT8u677kMxzKqgkr/Q=
MIME-Version: 1.0
In-Reply-To: <m13a0fc11w.fsf@fess.ebiederm.org>
References: <4B7BA24F.2010705@linux.vnet.ibm.com>
	 <364299f41002170910i336abf6eh72acbcbec9b72e7b@mail.gmail.com>
	 <20100218042532.GC13013@rishikesh.in.ibm.com>
	 <4B822F2E.9030609@cn.fujitsu.com>
	 <364299f41002212344v4873843ej986f1b39ec3494df@mail.gmail.com>
	 <4B8333ED.5080709@cn.fujitsu.com>
	 <364299f41002241718g4be216d1pbec918821b7027b0@mail.gmail.com>
	 <4B8F716E.5070207@cn.fujitsu.com>
	 <364299f41003041037s57f1d4bfr98c20ac7736b8905@mail.gmail.com>
	 <m13a0fc11w.fsf@fess.ebiederm.org>
Date: Thu, 4 Mar 2010 23:20:52 -0800
Message-ID: <364299f41003042320n7437e4a2j219b32a0a5f8dc50@mail.gmail.com>
Subject: Re: [LTP] [PATCH] sysctl03: sysctl returns EACCES after 2.6.33-rc1
From: Garrett Cooper <yanegomi@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Shi Weihua <shiwh@cn.fujitsu.com>,
       Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>,
       LTP <ltp-list@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 11:57 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Garrett Cooper <yanegomi@gmail.com> writes:
>
>> On Thu, Mar 4, 2010 at 12:38 AM, Shi Weihua <shiwh@cn.fujitsu.com> wrote:
>>> at 2010-2-25 9:18, Garrett Cooper wrote:
>>>> On Mon, Feb 22, 2010 at 5:48 PM, Shi Weihua <shiwh@cn.fujitsu.com> wrote:
>>>>> at 2010-2-22 15:44, Garrett Cooper wrote:
>>>>>> Ok.. one last thing.
>>>>>>
>>>>>> On Sun, Feb 21, 2010 at 11:15 PM, Shi Weihua <shiwh@cn.fujitsu.com> wrote:
>>>>>>> at 2010-2-18 12:25, Rishikesh K Rajak wrote:
>>>>>>>> On Wed, Feb 17, 2010 at 09:10:48AM -0800, Garrett Cooper wrote:
>>>>>>>>> On Wed, Feb 17, 2010 at 12:01 AM, Rishikesh <risrajak@linux.vnet.ibm.com> wrote:
>>>>>>>>>> Hi Shi,
>>>>>>>>>>
>>>>>>>>>> Thanks for your patch, still i am finding time to look into your patch.
>>>>>>>>>> Will reply you soon.
>>>>>>>>>>
>>>>>>>>>> http://marc.info/?l=ltp-list&m=126502355614857&w=2
>>>>>>>>>
>>>>>>>>> I looked at the patch finally.
>>>>>>>>
>>>>>>>> Thanks garret.
>>>>>>>>>
>>>>>>>>> Please use TTERRNO instead of strerror(...) for the reported value.
>>>>>>>>> There's no reason why you should use strerror(...) there as that's
>>>>>>>>> already done with tst_res(3).
>>>>>>>>
>>>>>>>> Shi, can you please incorporate changes which garret has suggested and
>>>>>>>> resend the patch again to ltp-list@ .
>>>>>>>
>>>>>>>  Ok, i recreated the patch based on garret's suggestion.
>>>>>>>
>>>>>>> Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>
>>>>>>> ---
>>>>>>> --- testcases/kernel/syscalls/sysctl/sysctl03.c.orig    2010-02-22 14:38:26.000000000 -0500
>>>>>>> +++ testcases/kernel/syscalls/sysctl/sysctl03.c 2010-02-22 15:08:03.000000000 -0500
>>>>>>> @@ -22,15 +22,18 @@
>>>>>>>  *     sysctl03.c
>>>>>>>  *
>>>>>>>  * DESCRIPTION
>>>>>>> - *     Testcase to check that sysctl(2) sets errno to EPERM correctly.
>>>>>>> + *     Testcase to check that sysctl(2) sets errno to EPERM or EACCES
>>>>>>> + *     correctly. But it will return EACCES on kernels that are 2.6.33-rc1
>>>>>>> + *     and higher.
>>>>>>>  *
>>>>>>>  * ALGORITHM
>>>>>>>  *     a.      Call sysctl(2) as a root user, and attempt to write data
>>>>>>>  *             to the kernel_table[]. Since the table does not have write
>>>>>>> - *             permissions even for the root, it should fail EPERM.
>>>>>>> + *             permissions even for the root, it should fail EPERM or EACCES.
>>>>>>>  *     b.      Call sysctl(2) as a non-root user, and attempt to write data
>>>>>>>  *             to the kernel_table[]. Since the table does not have write
>>>>>>> - *             permission for the regular user, it should fail with EPERM.
>>>>>>> + *             permission for the regular user, it should fail with EPERM
>>>>>>> + *             or EACCES.
>>>>>>>  *
>>>>>>>  * USAGE:  <for command-line>
>>>>>>>  *  sysctl03 [-c n] [-e] [-i n] [-I x] [-P x] [-t]
>>>>>>> @@ -43,6 +46,7 @@
>>>>>>>  *
>>>>>>>  * HISTORY
>>>>>>>  *     07/2001 Ported by Wayne Boyer
>>>>>>> + *     02/2010 Updated by shiwh@cn.fujitsu.com
>>>>>>>  *
>>>>>>>  * RESTRICTIONS
>>>>>>>  *     Test must be run as root.
>>>>>>> @@ -82,6 +86,7 @@ int main(int ac, char **av)
>>>>>>>  {
>>>>>>>        int lc;
>>>>>>>        char *msg;
>>>>>>> +       int exp_eno;
>>>>>>>
>>>>>>>        char osname[OSNAMESZ];
>>>>>>>        int osnamelth, status;
>>>>>>> @@ -96,6 +101,13 @@ int main(int ac, char **av)
>>>>>>>
>>>>>>>        setup();
>>>>>>>
>>>>>>> +       if ((tst_kvercmp(2, 6, 32)) <= 0){
>>>>>>> +               exp_eno = EPERM;
>>>>>>> +       } else {
>>>>>>> +               exp_eno = EACCES;
>>>>>>> +               exp_enos[0] = EACCES;
>>>>>>> +       }
>>>>>>> +
>>>>>>>        TEST_EXP_ENOS(exp_enos);
>>>>>>>
>>>>>>>        /* check looping state if -i option is given */
>>>>>>> @@ -114,13 +126,10 @@ int main(int ac, char **av)
>>>>>>>                } else {
>>>>>>>                        TEST_ERROR_LOG(TEST_ERRNO);
>>>>>>>
>>>>>>> -                       if (TEST_ERRNO != EPERM) {
>>>>>>> -                               tst_resm(TFAIL,
>>>>>>> -                                        "Expected EPERM (%d), got %d: %s",
>>>>>>> -                                        EPERM, TEST_ERRNO,
>>>>>>> -                                        strerror(TEST_ERRNO));
>>>>>>> +                       if (TEST_ERRNO != exp_eno) {
>>>>>>> +                               tst_resm(TFAIL|TTERRNO, "Got unxpected error");
>>>>>>>                        } else {
>>>>>>> -                               tst_resm(TPASS, "Got expected EPERM error");
>>>>>>> +                               tst_resm(TPASS|TTERRNO, "Got expected error");
>>>>>>>                        }
>>>>>>>                }
>>>>>>>
>>>>>>> @@ -147,12 +156,10 @@ int main(int ac, char **av)
>>>>>>>                        } else {
>>>>>>>                                TEST_ERROR_LOG(TEST_ERRNO);
>>>>>>>
>>>>>>> -                               if (TEST_ERRNO != EPERM) {
>>>>>>> -                                       tst_resm(TFAIL, "Expected EPERM, got "
>>>>>>> -                                                "%d", TEST_ERRNO);
>>>>>>> +                               if (TEST_ERRNO != exp_eno) {
>>>>>>
>>>>>> Why can't this be exp_enos[0] ?
>>>>>
>>>>> Using exp_enos[0] is ok. pls check the latest patch in this mail.
>>>>>
>>>>>>
>>>>>>> +                                       tst_resm(TFAIL|TTERRNO, "Got unxpected error");
>>>>>>
>>>>>> Typo.
>>>>>>
>>>>>>>                                } else {
>>>>>>> -                                       tst_resm(TPASS, "Got expected EPERM "
>>>>>>> -                                                "error");
>>>>>>> +                                       tst_resm(TPASS|TTERRNO, "Got expected error");
>>>>>>>                                }
>>>>>>>                        }
>>>>>>>
>>>>>>>
>>>>>>> Thank you.
>>>>>>> - Shi Weihua
>>>>>>
>>>>>>     It always helps to understand what's expected vs unexpected
>>>>>> without having to look at the source code. Could you please revise the
>>>>>> tst_resm format strings to be something like the following?
>>>>>>
>>>>>> tst_resm (TPASS | TERRNO, "Got expected error (errno = %d, ret_code =
>>>>>> %d", exp_errno_blah, exp_ret_code_blah);
>>>>>>
>>>>>> OR:
>>>>>>
>>>>>> tst_resm (TPASS | TERRNO, "Got unexpected error (expected errno = %d,
>>>>>> ret_code = %d - got errno = %d, ret_code = %d", exp_errno_blah,
>>>>>> exp_ret_code_blah, errno_blah, ret_code_blah);
>>>>>
>>>>> ret_code has not been defined in sysctl03.c, i think it's unnecessarily to
>>>>> import a new parameter. maybe, we can use your macro when it created. ;-)
>>>>>
>>>>> --- testcases/kernel/syscalls/sysctl/sysctl03.c.orig    2010-02-22 14:38:26.000000000 -0500
>>>>> +++ testcases/kernel/syscalls/sysctl/sysctl03.c 2010-02-23 09:35:20.000000000 -0500
>>>>> @@ -22,15 +22,18 @@
>>>>>  *     sysctl03.c
>>>>>  *
>>>>>  * DESCRIPTION
>>>>> - *     Testcase to check that sysctl(2) sets errno to EPERM correctly.
>>>>> + *     Testcase to check that sysctl(2) sets errno to EPERM or EACCES
>>>>> + *     correctly. But it will return EACCES on kernels that are 2.6.33-rc1
>>>>> + *     and higher.
>>>>>  *
>>>>>  * ALGORITHM
>>>>>  *     a.      Call sysctl(2) as a root user, and attempt to write data
>>>>>  *             to the kernel_table[]. Since the table does not have write
>>>>> - *             permissions even for the root, it should fail EPERM.
>>>>> + *             permissions even for the root, it should fail EPERM or EACCES.
>>>>>  *     b.      Call sysctl(2) as a non-root user, and attempt to write data
>>>>>  *             to the kernel_table[]. Since the table does not have write
>>>>> - *             permission for the regular user, it should fail with EPERM.
>>>>> + *             permission for the regular user, it should fail with EPERM
>>>>> + *             or EACCES.
>>>>>  *
>>>>>  * USAGE:  <for command-line>
>>>>>  *  sysctl03 [-c n] [-e] [-i n] [-I x] [-P x] [-t]
>>>>> @@ -43,6 +46,7 @@
>>>>>  *
>>>>>  * HISTORY
>>>>>  *     07/2001 Ported by Wayne Boyer
>>>>> + *     02/2010 Updated by shiwh@cn.fujitsu.com
>>>>>  *
>>>>>  * RESTRICTIONS
>>>>>  *     Test must be run as root.
>>>>> @@ -96,6 +100,12 @@ int main(int ac, char **av)
>>>>>
>>>>>        setup();
>>>>>
>>>>> +       if ((tst_kvercmp(2, 6, 32)) <= 0){
>>>>> +               exp_enos[0] = EPERM;
>>>>> +       } else {
>>>>> +               exp_enos[0] = EACCES;
>>>>> +       }
>>>>> +
>>>>>        TEST_EXP_ENOS(exp_enos);
>>>>>
>>>>>        /* check looping state if -i option is given */
>>>>> @@ -114,13 +124,12 @@ int main(int ac, char **av)
>>>>>                } else {
>>>>>                        TEST_ERROR_LOG(TEST_ERRNO);
>>>>>
>>>>> -                       if (TEST_ERRNO != EPERM) {
>>>>> -                               tst_resm(TFAIL,
>>>>> -                                        "Expected EPERM (%d), got %d: %s",
>>>>> -                                        EPERM, TEST_ERRNO,
>>>>> -                                        strerror(TEST_ERRNO));
>>>>> +                       if (TEST_ERRNO != exp_enos[0]) {
>>>>> +                               tst_resm(TFAIL|TTERRNO, "Got unxpected error "
>>>>> +                                       "(expected error = %d)", exp_enos[0]);
>>>>>                        } else {
>>>>> -                               tst_resm(TPASS, "Got expected EPERM error");
>>>>> +                               tst_resm(TPASS|TTERRNO, "Got expected error "
>>>>> +                                       "(errno = %d)", exp_enos[0]);
>>>>>                        }
>>>>>                }
>>>>>
>>>>> @@ -147,12 +156,12 @@ int main(int ac, char **av)
>>>>>                        } else {
>>>>>                                TEST_ERROR_LOG(TEST_ERRNO);
>>>>>
>>>>> -                               if (TEST_ERRNO != EPERM) {
>>>>> -                                       tst_resm(TFAIL, "Expected EPERM, got "
>>>>> -                                                "%d", TEST_ERRNO);
>>>>> +                               if (TEST_ERRNO != exp_enos[0]) {
>>>>> +                                       tst_resm(TFAIL|TTERRNO, "Got unxpected error "
>>>>> +                                               "(expected error = %d)", exp_enos[0]);
>>>>>                                } else {
>>>>> -                                       tst_resm(TPASS, "Got expected EPERM "
>>>>> -                                                "error");
>>>>> +                                       tst_resm(TPASS|TTERRNO, "Got expected error "
>>>>> +                                                "(errno = %d)",  exp_enos[0]);
>>>>>                                }
>>>>>                        }
>>>>
>>>> Ok, before I go and commit this, there are two things I need to know
>>>> (because trusty Google didn't turn up any results for this behavioral
>>>> change):
>>>>
>>>> 1. The change is legitimate.
>>>> 2. The documentation is up to date, or a bug has been filed for the
>>>> documentation change.
>>>>
>>>> If you can provide these two things, I'll commit the change.
>>>
>>> At this time of day, I can not find any documentation about EPERM->EACCES.
>>> But, i caught the kernel commit which caused ltp bug:
>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=26a7034b40ba80f82f64fa251a2cbf49f9971c6a
>>> Maybe it can help you to judge.
>>
>> Wow... that's a fair amount of code refactoring and additions to the syscall.
>>
>> Yes, all of the issues with opening a directory and reading/writing
>> now apply to sysctl(2), especially if someone attempts to read from a
>> write-only descriptor, or vice versa.
>
> No mismatches of file descriptor modes and how the descriptor is
> accessed can not occur.  There is a file descriptor but the file
> descriptor is completely internal to binary_sysctl(), and it is opened
> with the mode of what we are trying to use.  There are no user space
> controllable parts there.
>
> Looking through the old sysctl code it appears that it was a bug that
> kept it from returning EACCES.  The code has had this beautiful snippet
> in it for ages:
>
> static int test_perm(int mode, int op)
> {
>        if (!current->euid)
>                mode >>= 6;
>        else if (in_egroup_p(0))
>                mode >>= 3;
>        if ((mode & op & 0007) == op)
>                return 0;
>        return -EACCES;
> }

    Wow. Took a second for me to stare and it and see what you mean,
but yeah -- that is pretty dang awesome that it was always hardwired
to return 0.

> I admit that the manpage doesn't document EACCES but the manpage
> has always said don't use sysctl(2) so...

    Well, if someone bumbles across this later, it will be a confusing
issue to work through. It's better to be documented instead of
undocumented. I'll file the bug upstream to document this, but it
would be nice to determine if there are any more immediate gaps which
need to be addressed in the changes.

>> I hate to do this in such a reactive manner as this should have been
>> done up front, but the 1) documentation and 2) test need to be
>> updated. 1) is more key today because I'm not sure how much testing
>> the developer did before he committed to kernel.org, but without
>> updated documentation and requirements we can't write proper tests.
>
> You may see a slightly different error code from sysctl(2) on failure
> but otherwise  sysctl(2) should be unchanged, and yes I did test it.
> Of course I was not being picky about which error code I got on failure.

    Hmmm.. ok. We just get 20 questions when something fails and it's
not documented why it should fail in a particular manner :).

> What exists today is simply a backwards compatibility wrapper of
> sysctl(2) built on top of /proc/sys.  sysctl(2) was a practically
> unmaintained bit-rotting pile, that was never adequately maintained or
> tested.

    Yeah, you're probably right (especially because Linux tends not to
focus on sysctl(3) like the BSDs do).

> At this point nothing should change again until such time as the code
> is disabled/removed by default.

    Hmmm... ok. I assume that sysctl(2) is going completely out the
window in the future, in favor of what (just out of curiosity)? 100%
sysfs only tunables maybe?
Thanks,
-Garrett
