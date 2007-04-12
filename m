Return-Path: <linux-kernel-owner+w=401wt.eu-S1030580AbXDLRXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030580AbXDLRXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030581AbXDLRX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:23:29 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:46577 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030580AbXDLRX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:23:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SLHGMZrOefgAynqU7qrcAW3e9bJFXpDuePbWvCBnccYVWKkRo6U6svEM2j6KT/mwyW8cDi8oEzB8eqGr4nW0zI4XGFlZFX2iKsmHn56HN3Z+bbStMl092JGscjSu8KqfwT3DxBoQol3ajYYdHhAN5z94p740+9MBMnRmRoHXZSA=
Message-ID: <41840b750704121023h65edaae5td942e4093bb8b0a3@mail.gmail.com>
Date: Thu, 12 Apr 2007 13:23:27 -0400
From: "Shem Multinymous" <multinymous@gmail.com>
To: "Anton Vorontsov" <cbou@mail.ru>
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       dwmw2@infradead.org
In-Reply-To: <20070412151824.GA1886@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070411232503.GC20095@zarina>
	 <41840b750704120800l6ab2b0f8qeda6931d7c7e9bc6@mail.gmail.com>
	 <20070412151824.GA1886@zarina>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On 4/12/07, Anton Vorontsov <cbou@mail.ru> wrote:
> On Thu, Apr 12, 2007 at 11:00:07AM -0400, Shem Multinymous wrote:
> > I suggest adding "remaining operating time" and "remaining charging
> > time". You can try deducing these from the above attributes, but in
> > practice this gives very inaccurate predictions. On laptops (e.g.,
> > ThinkPad) the BIOS or EC often provides much better estimates, using a
> > more accurate physical model.
>
> Yes, sure. Feel free to add these attributes to the "standard" ones,
> along with your drivers. See (1).

That's a sound way to go around i. We just need to be careful about
naming conventions. For example, "*_charge" rather than "*_capacity,
so that we can later add "*_energy" analogously.

But specifically about {operating,charge} time remaining readouts, it
seems important to have them there from the beginning and have all
drivers implement them. Otherwise, userspace will just go ahead and
implement its own crude computation, so by the time when new
attributes and drivers are introduced, userspace will be full of bad
code. I've seen this happening with the tp_smapi ThinkPad driver -- I
introduced those attributes at a recent version, and then needed to
encourage userspace utility authors to dump their extrapolation
calcultions and use the attribute instead.

The rest of the missing attributes are not as imporant in this
respect, because userspace can't try to estimate them.

  Shem
