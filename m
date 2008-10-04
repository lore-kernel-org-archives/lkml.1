Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbYJDQ2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYJDQ2D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 12:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYJDQ1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 12:27:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:36330 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYJDQ1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 12:27:52 -0400
Message-ID: <ac3eb2510810040927s475c370ek7cc597309e35fa8f@mail.gmail.com>
Date: Sat, 4 Oct 2008 18:27:49 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
Cc: ambx1@neo.rr.com, elendil@planet.nl, trenn@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tpm@selhorst.net, rjw@sisk.pl, greg@kroah.com
In-Reply-To: <200810040931.44067.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <24565067.73831219353513508.JavaMail.servlet@kundenserver>
	 <200810031601.31322.bjorn.helgaas@hp.com>
	 <ac3eb2510810040509q24b26c8ek2bd6ca75343e2553@mail.gmail.com>
	 <200810040931.44067.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 4, 2008 at 5:31 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Saturday 04 October 2008 6:09:38 am Kay Sievers wrote:
>> On Sat, Oct 4, 2008 at 12:01 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>> > On Friday 22 August 2008 06:43:05 am Kay Sievers wrote:
>> >> On Fri, 2008-08-22 at 06:06 -0600, Bjorn Helgaas wrote:
>> >> > Since PNP currently doesn't generate any uevents or modalias files,
>> >> > I expect that a non-ACPI system will be unable to autoload modules
>> >> > for ISAPNP or PNPBIOS devices.  Right?
>> >>
>> >> They do create events, but without modalias. The shell script hack,
>> >> which udev runs, will make the event behave like it contained one.
>> >
>> > I'm finally looking at this again; sorry for the long hiatus.  I'm
>> > working on a patch to add PNP uevent support, modalias sysfs files
>> > for PNP, and file2alias.c changes to match, and I just want to
>> > make sure I'm understanding this correctly.
>>
>> Sounds good, just in mind, that there are custom modprobe configs out
>> there, that rely on the current pnp alias format, like:
>>   alias pnp:dPNP0510 irtty-sir
>>   alias pnp:dPNP0511 irtty-sir
>>   alias pnp:dPNP0700 floppy
>>   alias pnp:dPNP0303 atkbd
>>   alias pnp:dPNP0f13 psmouse
>>   ...
>> We should make sure, that this still works, which wouldn't if we just
>> do the acpi style aliases.
>
> My thought is to make PNP emit uevents with modaliases like
> "MODALIAS=pnp:PNP0501:PNP0500:" and make file2alias generate
> aliases like "alias pnp*:PNP0500:* 8250_pnp".

Looks good, and it is how they should look like. The current pnp
aliases are totally broken and useless for any usual modalias
matching.

> Modprobe configs like "alias pnp:dPNP0510 irtty-sir" would
> still work but would continue to depend on the udev shell hack.

The way the current shell hack is done, is that it gets disabled
automatically at the moment pnp events carry $MODALIAS.

> I don't have any plan for actually removing the hacks or doing
> any user-space transition.

Hmm, I guess there is no way around that. :)

Thanks,
Kay
