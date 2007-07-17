Return-Path: <linux-kernel-owner+w=401wt.eu-S936118AbXGQTwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936118AbXGQTwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933252AbXGQTwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:52:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:31938 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765275AbXGQTwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:52:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DAeFKh9lQmx67JpSxikFQwQE02GNaRSvmn+t0sFkOqt2xY2xXVVT+8M2Q9le7C8a3HIVRXvnrUhG++i9YMbjr5H0BfLe2x3sfJigpo9lFmKKnvJw8JvtPdA7+m9R7dFXZhxAd9cK0FNDFl3/ofyJ7zPTUE9/yPJF/2IEFRINSls=
Message-ID: <d120d5000707171252j501a25f5v56beae0c11462cb9@mail.gmail.com>
Date: Tue, 17 Jul 2007 15:52:07 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Christoph Pfister" <christophpfister@gmail.com>
Subject: Re: keyboard stopped working after de9ce703c6b807b1dfef5942df4f2fadd0fdb67a
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200707172101.06878.christophpfister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707132249.26106.christophpfister@gmail.com>
	 <200707132304.30795.christophpfister@gmail.com>
	 <d120d5000707160749r1084ab4ex8d2c4e89e6134d41@mail.gmail.com>
	 <200707172101.06878.christophpfister@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On 7/17/07, Christoph Pfister <christophpfister@gmail.com> wrote:
>
> Yep, attached (cold reboot, not pressing any keys, 2.6.21).
>

Ok, I see. You don't use PS/2 mouse and so BIOS told us that mouse is
absent and reassigned IRQ12 to EHCI controller. However we do not
listen to BIOS on i386 (for historucal reasons) and process with
registering AUX port... Now IRQ12 is shared between AUX port and EHCI
and the keyboard controller is unhappy wehereas before (with polling
timer) it would release IRQ12 and close port...

Does your keyboard start working if you boot with i8042.noaux?

-- 
Dmitry
