Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbYFIUxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbYFIUxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYFIUx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:53:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:17399 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbYFIUxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:53:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EYvqSk2+jfSu6jLAvV8o29++Tg1PnP5TrFK1GgrhrwUPNnC2IJYydZOJcCrYxKxz0s
         0F8RyOCGrDFKa/5kUAFgFENBpeOGca3TKdNVQqUBLaA9zqq52Doi70dB11t6hldV4d1+
         UyUvAa3y+kKjMRqD/qJObGM13UKM1vnFWO1ek=
Message-ID: <86802c440806091353m240ab7adocbaf5dacd15504f7@mail.gmail.com>
Date: Mon, 9 Jun 2008 13:53:24 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH 11/15] x86: move enabling of io_apic to prepare_cpus
Cc: "Glauber Costa" <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
In-Reply-To: <Pine.LNX.4.55.0806092058550.26593@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
	 <1213021018-14159-7-git-send-email-gcosta@redhat.com>
	 <1213021018-14159-8-git-send-email-gcosta@redhat.com>
	 <1213021018-14159-9-git-send-email-gcosta@redhat.com>
	 <1213021018-14159-10-git-send-email-gcosta@redhat.com>
	 <1213021018-14159-11-git-send-email-gcosta@redhat.com>
	 <1213021018-14159-12-git-send-email-gcosta@redhat.com>
	 <Pine.LNX.4.55.0806091620250.26593@cliff.in.clinika.pl>
	 <484D8813.4040807@redhat.com>
	 <Pine.LNX.4.55.0806092058550.26593@cliff.in.clinika.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2008 at 1:12 PM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
> On Mon, 9 Jun 2008, Glauber Costa wrote:
>
>> This one does enable_IO_APIC in the init_uniprocessor too, and should
>> account for the !smp case.
>
>  Hmm, it looks a little bit better, but why do you want to call
> enable_IO_APIC() separately in the first place?  There is a comment
> stating: "Enable IO APIC before setting up error vector," but why is it
> needed on 64-bit systems?  Especially as the very same system may run a
> 32-bit kernel and then it suddenly would not have to do this anymore?
> Strange...

that enable_IO_APIC() only call record old ioapic/pin for timer and
clear_IO_APIC.

we need clear_IO_APIC before enable setup error vector, in case there
is wrong setting in ioapic by BIOS...

YH
