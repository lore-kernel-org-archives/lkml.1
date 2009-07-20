Return-Path: <linux-kernel-owner+w=401wt.eu-S1752498AbZGTS1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbZGTS1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZGTS1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:27:13 -0400
Received: from web50110.mail.re2.yahoo.com ([206.190.38.38]:42686 "HELO
	web50110.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751713AbZGTS1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:27:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=GRfyv314AHXvGUxDzrGsP+/pwUoCcUULpnWejeH8YzKPcPsKlaiZMfEx4JL3Cv3+g6I9NcOqJvzB2OIxeReUe2qhd094+3L7UAz+W/5vKv9UPbFntqXTibGQ8+7U3dMJ7aw4nGLwlSBoseh+j2yf/bh8uE/v9IJjGWQn0itV7Xc=;
Message-ID: <935428.51568.qm@web50110.mail.re2.yahoo.com>
X-YMail-OSG: y4Uit_0VM1kIqt7f.FBqYr5geqtsF_Pmb4LIwku0Ox0FFHt2krLvSk_oflEKMFUQL88ZAIEcaI9eY3zCEWuK.0t5XSzjF1qwNcXFHgT3Rqc80wR3uFDXzBXzbFHfsP6fR27KmOKHC7UdXG0Xz4sfQ7j3S96tHqOYn8qzyKv2ssfAZsz._AqNhb7o5vCrzct.od2DFWM1R2vFbhphHT8ONKYzwObc48hMEcVcfHiE_ZKjvXlidNjAjmMO.qVNIVLria_XFeiGc598q0yTXtfBnZF2J5YB.e8UAaitfBljePT1sAqw2wFAE7mJfs1bJEX5v7Db62Xas1qcIdh3UVSq
X-Mailer: YahooMailClassic/6.0.18 YahooMailWebService/0.7.338.1
Date: Mon, 20 Jul 2009 11:27:12 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding
To: Borislav Petkov <borislav.petkov@amd.com>,
       Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, aris@redhat.com,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20090720180446.GB16072@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 7/20/09, Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <andi@firstfloor.org>
> Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding
> To: "Borislav Petkov" <borislav.petkov@amd.com>
> Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, norsk5@yahoo.com, aris@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org, "Andi Kleen" <andi@firstfloor.org>
> Date: Monday, July 20, 2009, 12:04 PM
> On Mon, Jul 20, 2009 at 06:12:58PM
> +0200, Borislav Petkov wrote:
> > Use a weakly defined symbol instead of ugly ifdefs.
> 
> I'm not sure what you're trying to achieve, 

The goal is to have a default handler within the kernel and a more specific handler in a module after it has loaded. Using the weak symbol as a mechanism to do that. I haven't used that, so I don't know if it works.

> but if you're
> trying to catch corrected MCs you're hooking into the 
> wrong function. print_mce is only called for PCC=1.
> 
> Also if you're checking for specific banks you
> need to check for vendor/cpu model first of course.
>
> In your current implementation e.g. a Intel CPU
> would pass some random event into your AMD specific code,
> which is probably not intended and might even crash.

On an Intel CPU based system, the AMD EDAC module wouldn't load due the missing AMD PCI Vendor/Device ID values during the module probe phase.

> 
> It would be probably cleaner if you defined a standard
> notifier chain interface.

That might be a better and explicit solution

doug t


> 
> -Andi
> 
