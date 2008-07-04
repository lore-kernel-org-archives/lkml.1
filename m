Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbYGDVpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbYGDVpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 17:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYGDVpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 17:45:34 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:56304 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbYGDVpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 17:45:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eX8eTvrUAnJf4nOkY20N7Ajc8qJhB19v4SpWcQzGijTI0Gio3otb2jrCG0BLILMmYT
         8oNEE/zeashvVYNpClD10qsvtwa2wGoC6Bsrl0i2dJYf2yY6ovK0ofhorJZmmhtnRbnM
         6lc+6FHzMwlyXGA4BVRiD88ntx50B1+q3QNNA=
Message-ID: <dd18b0c30807041445t2ffe1b80k7d33ca6233207f42@mail.gmail.com>
Date: Fri, 4 Jul 2008 21:45:29 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Alexey Starikovskiy" <aystarik@gmail.com>
Subject: Re: dsdt buggy acpi
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>
In-Reply-To: <dd18b0c30807040923v37e2d8c3id680d76b9cf494bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806302339q7b3effybf8a7f619b009262@mail.gmail.com>
	 <20080702082555.0959ef2b@linux360.ro>
	 <20080702100935.GA699@srcf.ucam.org>
	 <20080702144820.29f7d43d@linux360.ro>
	 <20080702115527.GA3396@srcf.ucam.org>
	 <dd18b0c30807020930u43405fd5v2e328b6b76b833b0@mail.gmail.com>
	 <20080702163510.GA8912@srcf.ucam.org>
	 <dd18b0c30807021037g3faffa6kd1ef26f888f36d11@mail.gmail.com>
	 <486E0A64.5020903@gmail.com>
	 <dd18b0c30807040923v37e2d8c3id680d76b9cf494bf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2008 at 4:23 PM, Justin Mattock <justinmattock@gmail.com> wrote:
> On Fri, Jul 4, 2008 at 11:32 AM, Alexey Starikovskiy <aystarik@gmail.com> wrote:
>> Justin Mattock wrote:
>>>
>>> On Wed, Jul 2, 2008 at 4:35 PM, Matthew Garrett <mjg59@srcf.ucam.org>
>>> wrote:
>>>
>>>>
>>>> On Wed, Jul 02, 2008 at 04:30:11PM +0000, Justin Mattock wrote:
>>>>
>>>>
>>>>>
>>>>> Hello; what info is supplied with EFI i.g. I'm using a macbook pro.
>>>>> After looking at:
>>>>> http://acpi.sourceforge.net/dsdt/view.php I was unable to locate
>>>>> anything with apple, or at least
>>>>> couldn't find the manufacture number.
>>>>> If somebody has already done this, I was wondering if it would be O.K.
>>>>> if I can attached my dsdt.dsl with the errors,
>>>>> and my explanation of what I changed, just so If I did something
>>>>> completely wrong
>>>>>
>>>>
>>>> iasl will complain about code that the Linux interpreter will happily
>>>> accept. If the only reason you've made changes is that iasl complains,
>>>> then it's unlikely that there's any functional difference as a result.
>>>> Otherwise, work out which changes fix which Linux bugs and file a bug
>>>> at bugzilla.kernel.org against acpi.
>>>>
>>>> --
>>>> Matthew Garrett | mjg59@srcf.ucam.org
>>>>
>>>>
>>>
>>> Hello; I modified dsdt because iasl was complaining, As a result like
>>> what you said
>>> "then it's unlikely that there's any functional difference as a
>>> result" is probably
>>> what I'm seeing. As for a bug report I already have one filed. As to
>>> why I'm messing with
>>> the dsdt, just trying to isolate the problem with the bug I have
>>> already filed., or at least
>>> get a better idea of what is happening. Anyways thanks for the info.
>>> regards;
>>>
>>>
>>
>> For difference, you should look for "Darwin", this is how MacOS X identifies
>> itself to hardware.
>>
>>
>> Regards,
>> Alex.
>>
>
> Hello;
> So adding acpi_osi=Darwin will work for boot parameter. Also I wanted
> to apologize If I pissed you off,
> I didn't quite understand what was really happening, and now after
> looking into the scenario, I think I need to find out
> what is going on with my GPE's, this way you're detector(ec.c) won't
> be going off so frequently.
> regards;
>
> --
> Justin P. Mattock
>

Hmm I like this option(never new it existed), the only problem I'm seeing right
now is no battery info in /proc/acpi, "but there is no gpe storm which
makes me happy".
After searching I'm looking at the same as this:
http://lists.opensuse.org/opensuse-bugs/2007-08/msg09525.html
Overall the outcome of using sbs is bad with the Darwin option, system
sticks after loading
the module during boot. even under different proceedures
i.g. with
sbs=only (no a/c and battery modules)
sbs+ac(module)
sbs+ac+battery(modules)

regards;


-- 
Justin P. Mattock
