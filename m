Return-Path: <linux-kernel-owner+w=401wt.eu-S1760687AbZEFSjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbZEFSjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 14:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbZEFSjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 14:39:01 -0400
Received: from web50106.mail.re2.yahoo.com ([206.190.38.34]:34472 "HELO
	web50106.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752274AbZEFSjA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 14:39:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=4P90j1O009tipi41ZPnTUqOtH7qEIQGAp3qnH1UHgRJ6ODVxsn7VHZXzf0vzue+vAPztQ1cA1nqX/2/RPRZevZ4wR7b/0dlTlKCz6ROPBPc9E7kKOgGO86bkR8U6HKK/g9dhSJ/Ll7uRRW+WS9BS0DWw0xdfWtDgXSfZhcDqeV8=;
Message-ID: <195072.53660.qm@web50106.mail.re2.yahoo.com>
X-YMail-OSG: eToYjygVM1lpLmO_rLjtK4jbwfiYFSPRQfA.95A2BYZY943728m9vhGz6666W_vmpP8T_Xizm4hc718pNJ8c_fdokYamXr1RVeNBtte11cWp43sI7jWm3DR1GsMbkVZ6BmsPzgt3b1r4OVTLL9jZotCJQ_rNRfXQEjA7e0zaskhRROam3pGl7mWb3s0dRKRRA0ey8BYR8BQOyFtKBDmbSDLz13xCTSJQGKGijd0m2cCtbrNJ7mv6FtN579GfnzWQmHqw9G4K2FpDgTcabwE9RbbB_waX6r52AA56Kh5YTLJVm4WmrAPErDu4EnHa0EZO
X-Mailer: YahooMailClassic/5.3.9 YahooMailWebService/0.7.289.10
Date: Wed, 6 May 2009 11:38:59 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 09/21] amd64_edac: assign DRAM chip select base and mask in a family-specific way
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>, akpm@linux-foundation.org,
       greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- On Tue, 5/5/09, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> Subject: Re: [PATCH 09/21] amd64_edac: assign DRAM chip select base and mask in a family-specific way
> To: "Doug Thompson" <norsk5@yahoo.com>
> Cc: "Borislav Petkov" <borislav.petkov@amd.com>, akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com, linux-kernel@vger.kernel.org
> Date: Tuesday, May 5, 2009, 3:39 PM
> Em Tue, 5 May 2009 12:28:01 -0700
> (PDT)
> Doug Thompson <norsk5@yahoo.com>
> escreveu:

> > BACKGROUND: The error checking of the pci config space
> read was added during the time when the kernel couldn't read
> the extended 4k config space via the AMD IOConfig port
> access function (12 bits of offset) not via MMCONFIG. 
> 
> As this is unlikely to happen, I would also replace the:
>     if (err != 0)
> 
> by:
>     if (unlikely(err))
> 
> in order to optimize the tests a little bit, avoiding the
> risk of cache flushes due to the branches.
> 
> Cheers,
> Mauro
> 

when the driver is configured without DEBUG config flag on, the statement becomes:

    if (exp)
         ;

which with a good optimizer the code disappears altogether in the production condition. Only with DEBUGGING on will these outputs be generated.

thanks for the extra review eyes

doug t

