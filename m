Return-Path: <linux-kernel-owner+w=401wt.eu-S1758395AbYFBIOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395AbYFBIOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 04:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYFBIOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 04:14:31 -0400
Received: from styx.suse.cz ([82.119.242.94]:58383 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752867AbYFBIOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 04:14:30 -0400
Date: Mon, 2 Jun 2008 10:14:28 +0200
From: Jan Kara <jack@suse.cz>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: UBIFS seekdir()/telldir() issue
Message-ID: <20080602081428.GA30613@duck.suse.cz>
References: <483AC0ED.5060805@nokia.com> <20080528154525.GA32634@atrey.karlin.mff.cuni.cz> <483FDDA9.4020401@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483FDDA9.4020401@nokia.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 30-05-08 13:57:45, Adrian Hunter wrote:
> Jan Kara wrote:
>>   The sequence you write above is actually incorrect I think. Noone
>> guarantees that the cookie returned by telldir() is valid after
>> closedir(). What is a bigger (and quite common) problem is, if somebody
>> uses readdir/telldir/seekdir while someone else creates/deletes files in
>> the directory. The standard implies in this case that subsequent
>> readdir should return all the files which were not touched (or all files
>> after position set by seekdir if used...).
>
> Not according to this:
>
> http://www.opengroup.org/onlinepubs/009695399/functions/readdir.html
>
> 	"If a file is removed from or added to the directory after the
> 	most recent call to opendir() or rewinddir(), whether a
> 	subsequent call to readdir() returns an entry for that file
> 	is unspecified."
  This is exactly what I meant. Maybe phrased it wrongly in my email :)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
