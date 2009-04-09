Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbZDID4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbZDID4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 23:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757269AbZDID4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 23:56:35 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:41543 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753598AbZDID4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 23:56:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nr7PQk8+5EFe6vktMq7TRZFpCs+DrXcsazrdbwoS0CeMqWqUn986ivfJxWeWdxMvqYS4U5G27WRYnEtcCvYhhAzq2OUc0qk+TKskPmr4rhRbWb/HG3YpQGK9oJ6TwITsB6S+QHR2SpBfBMjJuoE07NlRDGYtzyWYT8ypbOm7L14=  ;
X-YMail-OSG: MnhXsn0VM1k7S2yr35uuWY_2IKcezaqD0YLVQq8m9On6WJnfnMKH4qenm6E2viDD_q7.aL.23pnk5T_XZGZhe8qELKRykRUkfHVnkqL1DESNktzIMFmi9qGVHNA5fMf_5ZKm2FTtLVY_wGccvY7gnyMjiC0oRtFYYQfHjlctoKeUukcBf9P78jdh5_d5Gy0Tx8at8onFqPWZTKlSapcmoeq8baPM.7k7ydEjp9apDcJg5z6LtqeV1DnZgcdboLr9h8WuS.CPxah_EZszSC.c98_xuAweMZD8JFbmRc8tuVrIpCsvv4mz
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Matt Klein <matt.klein@pikewerks.com>
Subject: Re: Cached IO Synchronization Question
Date: Thu, 9 Apr 2009 13:56:27 +1000
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
References: <49DA7498.3050000@pikewerks.com> <1239204217.4557.2590.camel@laptop> <49DCC936.70509@pikewerks.com>
In-Reply-To: <49DCC936.70509@pikewerks.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904091356.27466.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 April 2009 01:56:38 Matt Klein wrote:
> > 
> > Note how do_generic_file_read() checks PageUptodate() and does a
> > lock_page_killable() in case its not.
> > 
> > 
> > 
> 
> As far as I can tell there is nothing to prevent the page from becoming
> out of date (or someone doing a full page cached write) after the
> PageUptodate() check returns up to date.

Anything which marks the page not uptodate does not change the actual
page data, so the copy will still copy over valid data.

There is otherwise no synchronisation between reads and writes.

All we care about is that the data has been valid at some point in
time.

 
> So I have concluded that cached read/write interleaving is not
> synchronized. This is the behavior found on Windows.

Right.
 

