Return-Path: <linux-kernel-owner+w=401wt.eu-S1757788AbYEKS3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbYEKS3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 14:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756588AbYEKS3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 14:29:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:62050 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465AbYEKS3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 14:29:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=phmpaMZfcIGVpfU27Gza1MZUet0RaTnwf5fLfWzXXq1bjzbvdJ1dltxZ6Z/NQkXgZLMSlKNQIQtDn+DD7dVNx3QiIotrDoE0QhOPkAJe1Mboy8HTxZurcNqVAmDk2UDrUIrnFpe6ouhCVfXyDfjmcvGh6lellBo8EeC3q8wSTe4=
Date: Sun, 11 May 2008 22:29:05 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Mikael Pettersson <mikpe@it.uu.se>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc1 on x86: ld: warning: dot moved backwards before
	`.text'
Message-ID: <20080511182905.GD6942@cvg>
References: <18470.787.498329.144701@harpo.it.uu.se> <482604D1.7020804@zytor.com> <20080510211602.GA32339@uranus.ravnborg.org> <20080511154411.GB6942@cvg> <482737A8.4040602@zytor.com> <20080511182440.GC6942@cvg> <48273A32.5020104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48273A32.5020104@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Sun, May 11, 2008 at 11:25:54AM -0700]
> Cyrill Gorcunov wrote:
>> Hi Peter,
>> actually I only doubt about exactly position of this headers - I mean
>> meguess it better should be _before_ "_end" not after. Since the others
>> script uses (acpi/wakeup_rm.S):
>> 	wakeup_code_start:
>> 	.incbin	"arch/x86/kernel/acpi/realmode/wakeup.bin"
>> 	wakeup_code_end:
>> and kernel uses these wakeup_code_* marks to save/restore memory I think
>> it should be like
>> 	. = HEADER_OFFSET;
>> 	.header : {
>> 		...
>> 	}
>> 	. = ALIGN(16);
>> 	_end = .;
>> 	/DISCARD/ ...
>
> Yes, I believe that's correct.
>
> 	-hpa
>

Thanks for review, Peter, I'll cook a patch and wait for
Pavel's opinion ;-)

		- Cyrill -
