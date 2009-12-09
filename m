Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbZLIIoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbZLIIoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 03:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZLIIoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 03:44:09 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:33293 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbZLIIoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 03:44:08 -0500
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Dec 2009 03:44:08 EST
Date: Wed, 9 Dec 2009 09:34:37 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org
Subject: Re: [PATCH 3/7] mtrr: Remove use_intel()
Message-ID: <20091209083437.GA27838@rere.qmqm.pl>
References: <1-1000-25639-1260344705-9533@rere.qmqm.pl> <4-1000-25639-1260344705-9533@rere.qmqm.pl> <86802c440912090010q3aa9c701u75fbba19d43308e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86802c440912090010q3aa9c701u75fbba19d43308e0@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 12:10:50AM -0800, Yinghai Lu wrote:
> 2009/12/8 Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>:
> > Remove use_intel() and use is_cpu(INTEL) instead.
> >
> > .use_intel_if is duplicating information already found in .vendor, as
> > the only combinations used are:
> >    generic: use_intel_if == 1, vendor == INTEL
> >    amd/cyrix/centaur: use_intel_if == 0, vendor != INTEL
> >
[...]
> can you check it with amd64 cpu?

Unfortunately I don't have any AMD machines right now.

Anyway, just to clarify why the change is a functional no-op: use_intel()
and is_cpu(X) don't check the detected CPU vendor ID but look into mtrr_ops
struct. For 64BIT build this means that use_intel() / is_cpu(INTEL) == true
when mtrr_if != NULL, and all other is_cpu() == false because no other
implementation could be choosen (amd/cyrix/centaur special cpu features are
possible only in 32BIT).

Best Regards,
Micha³ Miros³aw
