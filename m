Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbZHYTHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbZHYTHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755711AbZHYTHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:07:30 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:36367 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbZHYTH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:07:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uO6UJWjfkeIKSslGwbbHieOtLapfRWteGqISafKIeoNLnNXFDEzECuPV5sMJpcLGve
         JE7+wugSczm4zVQkUCAPGY57jdzCKZisW9AfNDqcIAE/m7DjhQ+5Jg6nFP6VgBldQkkG
         73HLa1x8Bpwxjxm1+ARTJJO3tkB3swjlKUh5c=
Date: Tue, 25 Aug 2009 22:59:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       shai@scalex86.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
Message-ID: <20090825185911.GB5806@lenovo>
References: <20090824182659.GA6842@localdomain> <4A932809.1000103@kernel.org> <20090825012632.GB6842@localdomain> <4A9372A1.9090905@kernel.org> <20090825171716.GC6456@localdomain> <20090825181500.GB3277@elte.hu> <20090825183130.GA5806@lenovo> <4A943290.5080606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A943290.5080606@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Tue, Aug 25, 2009 at 11:50:56AM -0700]
...
| > | We should revert to the .30 behavior unless there's a good reason 
| > | (even in that case we'll solve the regression and do a workaround 
| > | for vSMP). Yinghai?
| > | 
| > | 	Ingo
| > 
| > I'm definitely not APIC expert but since I was partially involved
| > letme turn in.
| > 
| > Original commit which causes problem for vSMP seems to be due
| > to cpu_has_apic bit turned off (ie due to being manually disabled
| > or acpi table broken) so further read apic id will return plain
| > zero (we're talking about 64 bits now). So frnakly I don't understand
| > what is wrong with Ravikiran's patch. In case of apic disabled
| > initial apic value will be used anyway (which is latched but
| > actually may be changed, but it's not our case).
| 
| initial apic id and apic id could be different.

yes, I know. initial one is latched by pins though still
could be changed (not always).

| 
| and we should use initial apic id to get correct phys pkg id in case BIOS set crazy apic id.

indeed, as function name implies. Need more code reading...
So (64 bits) at least generic_identify is not guilty since it uses initial
one from scratch. Need more code reading...

| 
| YH
| 
	-- Cyrill
