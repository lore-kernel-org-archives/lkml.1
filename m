Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbZBSLyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbZBSLyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbZBSLyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:54:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:6094 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbZBSLyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:54:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=H1Nx+s/W8W2HeL63TQYrKE4s7v0hRIRyJNRR9z4wHJGq5ypR/4f2f/X8RkeNPzNAuU
         6zSjht7/4HlSK7pDWjkBXlRyHiYq75n3BdPYIvKQIa4iOBaggWrgxQy/BEXZL0FFXcb5
         HRqOkmvli9y2v06/NtDgCwnHxy5kWcb277ruQ=
MIME-Version: 1.0
Reply-To: alan-jenkins@tuffmail.co.uk
In-Reply-To: <20090218190943.GF26802@elte.hu>
References: <20090218182822.GA19902@srcf.ucam.org>
	 <20090218183137.GD26802@elte.hu>
	 <20090218183641.GA20203@srcf.ucam.org>
	 <20090218190943.GF26802@elte.hu>
Date: Thu, 19 Feb 2009 11:54:06 +0000
Message-ID: <9b2b86520902190354m259f85d0n97795da7b1b8afdd@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Change link order of x86 cpufreq modules
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, davej@codemonkey.org.uk,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/18/09, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
>> On Wed, Feb 18, 2009 at 07:31:37PM +0100, Ingo Molnar wrote:
>>
>> > Nice fix! Where does this information come from? Distro module
>> > ordering magic? It's rather non-trivial.
>>
>> Pretty much. p4-clockmod is never the preferred option because
>> it does no voltage scaling. speedstep-centrino is now almost
>> entirely functionally replaced with acpi-cpufreq. The
>> powernow-k8 issue was a personal communication from davej.
>
> I'm wondering whether that priority order should/could be
> expressed in the module space too - so that distros wouldnt have
> to replicate this. This is really a piece of information the
> kernel is best at maintaining.

The latest development version of module-init-tools (in the git tree)
is designed to preserve the kernel link order when resolving builtin
aliases.  If you have two modules which provide the alias "pci:123",
they will be loaded in the same order as if they were builtin drivers.

It should work if all the cpufreq drivers provide an alias
"cpufreq-driver" and userspace just does "modprobe cpufreq-driver".
You just need to be sure none of the cpufreq drivers provide *other*
aliases which cause them to be loaded earlier, by udev or some other
bootscript.

Alan
