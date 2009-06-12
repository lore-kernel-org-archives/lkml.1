Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbZFLRWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbZFLRWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZFLRWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:22:48 -0400
Received: from mail-yx0-f200.google.com ([209.85.210.200]:38168 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbZFLRWr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:22:47 -0400
X-Greylist: delayed 52648 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jun 2009 13:22:47 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KCXrsVlsv+GBIb32XVqd1gArThwiiACE3Xtc7mlJnU+yF5in+hiMP2vqJnIB6TwXzf
         2XNDz+gySuPjKjqTi/3jNfuPEDc3Z8Kfz44QKit0upVaAlkw9j1Uia4Hk2PzDx5OFub9
         zjJb2gP7aCiWBTwrK4mEpLuKbXZpKKVvgeJ9A=
MIME-Version: 1.0
In-Reply-To: <adak53h1q29.fsf@cisco.com>
References: <86802c440906111945n2a42dc94mf08bd2b1a252842f@mail.gmail.com>
	 <adak53h1q29.fsf@cisco.com>
Date: Fri, 12 Jun 2009 10:22:49 -0700
Message-ID: <86802c440906121022s532ee0f7tc556251d22ffd139@mail.gmail.com>
Subject: Re: mthca double free irqs
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: "Barnes, Jesse" <jesse.barnes@intel.com>, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 7:31 AM, Roland Dreier<rdreier@cisco.com> wrote:
> Thanks, will take a look.  It does seem this is on an error path:
>
>  > [  606.818317] ib_mthca 0000:c4:00.0: NOP command failed to generate
>  > interrupt (IRQ 98), aborting.
>  > [  606.826709] ib_mthca 0000:c4:00.0: BIOS or ACPI interrupt routing problem?
>
> So your system already had problems -- the driver didn't get an
> expected interrupt from the device.

I knew that. but we should not get that double freeing.

BIOS doesn't allocate proper MMIO range for that card.

YH
