Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbZHHAmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbZHHAmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 20:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757356AbZHHAmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 20:42:44 -0400
Received: from web50105.mail.re2.yahoo.com ([206.190.38.33]:46877 "HELO
	web50105.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757335AbZHHAmo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 20:42:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=splbeEhS8ZI2sUN48nPAoqLcnZOpZCUcWDBxgEaxcschSKtLl2vm+oTmvcLtBiw0v+Sh5E8pktsO9ELkdccJeWD0PB+kg5AEVbHHc7aTKQybC8fAaSKi8tbQYHb4+n59z8h8GC46MAO3AcFT7yJYOaOa2U99Ssenoe/9tg8JO7A=;
Message-ID: <678970.61399.qm@web50105.mail.re2.yahoo.com>
X-YMail-OSG: Nk8zh3IVM1nphwF58bU7drsz8fxENlOd5D3bYk_28qiruo.dmPXZbTLXZ50hmZOiDKy4pzEHqGRkVBvEKqsSnXAlmJQ4Q4lvT0mwfisM5YqvNl0pfMekUl37vJ0D_85Jf6NygMLOC0nwfveSunr1c6L2uYU2BW1ULHtFZmxJm0iFOs9PsbpyskgIqdV6DQDMfBhUZNAnLr_HZLLax4buuGwUJT7FKNA7az3vQ4RefPCW5FWmlPO1TiBtYC78tPh8PyZ6YfaPbiBnZUfdg.0jIz4YUcKeTArmu5fcpk4qLVdPK_bVtPVSnAmtAlxlZNPVKIXRTteZBbhErGEJ2UxUoIu.8d9OZllzhHYuclM-
X-Mailer: YahooMailClassic/6.1.2 YahooMailWebService/0.7.338.1
Date: Fri, 7 Aug 2009 17:42:44 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: Bugs in intel 5400 EDAC driver
To: linux-kernel@vger.kernel.org, Jeff Roberson <jroberson@jroberson.net>
Cc: bluesmoke-devel@lists.sourceforge.net
In-Reply-To: <alpine.BSF.2.00.0908071312030.19226@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 8/7/09, Jeff Roberson <jroberson@jroberson.net> wrote:

> From: Jeff Roberson <jroberson@jroberson.net>
> Subject: Bugs in intel 5400 EDAC driver
> To: linux-kernel@vger.kernel.org
> Date: Friday, August 7, 2009, 5:23 PM
> Hello,
> 
> The i5400 EDAC driver has several bugs with chip-select row
> computation which most likely lead to bugs in detailed error
> reporting.  Attempts to contact the authors have gone
> mostly unanswered so I am presenting my diff here.  I
> do not subscribe to lkml and would appreciate being kept in
> the cc.

Will do

Can you generate a patch, which will provide better closure than just text?

doug t

CC to the bluesmoke mailing list where most edac developers read

> 
> The most egregious problem was miscalculating the addresses
> of MTR registers after register 0 by assuming they are 32bit
> rather than 16. This caused the driver to miss half of the
> memories.  Most motherboards tend to have only 8 dimm
> slots and not 16, so this may not have been noticed before.
> 
> Further, the row calculations multiplied the number of
> dimms several times, ultimately ending up with a maximum row
> of 32.  The chipset only supports 4 dimms in each of 4
> channels, so csrow could not be higher than 4 unless you use
> a row per-rank with dual-rank dimms.  I opted to
> eliminate this behavior as it is confusing to the user and
> the error reporting works by slot and not rank.  This
> gives a much clearer view of memory by slot and channel in
> /sys.
> 
> Thanks,
> Jeff
