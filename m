Return-Path: <linux-kernel-owner+w=401wt.eu-S1760842AbYGACLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760842AbYGACLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 22:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbYGACKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 22:10:49 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:34848 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbYGACKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 22:10:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kbg8SIiSszRB040HgOu2XrHtSt3DQMIQ3XxYq7Ct1Z9Ane+IFXFhc+c6+rVZ9Izfm/
         VdEg63nwMk7ntHpJU9Pw/wQE5qNPc6jMIbU/2MFqlXKfZhiyM2dlmFMzBH7J7LqxVQm0
         ruWmE2NnOvH4bguoFNYXq2rTCsxc9QWBGrVZ0=
Message-ID: <dd18b0c30806301910j32668e9ufad8ec04a3784152@mail.gmail.com>
Date: Tue, 1 Jul 2008 02:10:44 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: GPE storm detected, disabling EC GPE
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org,
       "Alexey Starikovskiy" <alexey.y.starikovskiy@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <200806302159.51768.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806051401j28a57871ke4e1c76a4c8ea425@mail.gmail.com>
	 <20080630123454.7f48b7e0.akpm@linux-foundation.org>
	 <200806302159.51768.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 7:59 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, 30 of June 2008, Andrew Morton wrote:
>> On Thu, 5 Jun 2008 21:01:55 +0000
>> "Justin Mattock" <justinmattock@gmail.com> wrote:
>>
>> > FWIW I noticed a post where the person had changed 5 to 20, and it
>> > seemed to work for them;
>> > So with that in mind I decide to give that a go, here is the location:
>> > drivers/acpi/ec.c
>> > @@ -527,47 +488,51 @@ static u32 acpi_ec_gpe_handler(void *data)
>> >  {
>> >         acpi_status status = AE_OK;
>> >         struct acpi_ec *ec = data;
>> >        u8 state = acpi_ec_read_status(ec);
>> >
>> >         pr_debug(PREFIX "~~~> interrupt\n");
>> >        atomic_inc(&ec->irq_count);
>> > -       if (atomic_read(&ec->irq_count) > 5) {
>> > +       if (atomic_read(&ec->irq_count) > 20) {
>> >                pr_err(PREFIX "GPE storm detected, disabling EC GPE\n");
>> >                ec_switch_to_poll_mode(ec);
>> >                goto end;
>> >        }
>> >
>> > Now I don't know if this will work for other brands, but for
>> > me(Macbook Pro ATI chipset) I have not received the
>> > GPE storm detected, disabling EC GPE message, but it's only been an
>> > hour, maybe after two or three this might appear.
>> > Also is this good or bad to set 5 to 20 for the system?
>> > regards;
>>
>> We've had a few reports of this GPE-storm problem and I've rather lost
>> track of what's happening.  Has anyone looked into it?
>
> Yes, the problem is still being worked on, AFAICS.
>
>> If not, do we have a bugzilla report where we can work on this?
>
> There's a bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=10724 .
>
> Thanks,
> Rafael
>

Hello; I must be honest I'm not real sure on what Is happening with
this. The above: if (atomic_read(&ec->irq_count) > 20) {
just prolongs the message from going off(doesn't deal with the main problem).
Now it is interesting from over here with a macbook, due to this message having
to deal with the battery(if that's the case) i.g. removing the battery
results in no gpe storm being detected(or not too many interrupts), on
the contrary the other laptops acer or whatever was experiencing the
same issue, was in something completely different. Now just out of
curiosity
I was thinking back to when this wasn't happening and it must have
been around april or so, after looking at the activity with acpi the
only
real scenario I saw that might have led to this would be:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=cf7acfab032ff262f42954328cdfd20a5d9aaaac
/ but like I said out of curiosity maybe this was what might be
triggering
the interrupts to fire this message off, but could be something
completely in an other location.
As for right now I'm open to any ideas.
regards;

-- 
Justin P. Mattock
