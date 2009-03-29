Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbZC2MSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbZC2MSo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 08:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZC2MSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 08:18:33 -0400
Received: from agrajag.mansr.com ([78.86.181.102]:58303 "EHLO mail.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbZC2MSc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 08:18:32 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Mar 2009 08:18:32 EDT
To: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: Zero length files - an alternative approach?
References: <87bprka9sg.fsf@newton.gmurray.org.uk>
	<yw1xab744lqi.fsf@thrashbarg.mansr.com>
	<49CF636A.3030400@ursus.ath.cx>
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Date: Sun, 29 Mar 2009 13:10:23 +0100
In-Reply-To: <49CF636A.3030400@ursus.ath.cx> (Andreas T. Auer's message of "Sun, 29 Mar 2009 14:02:50 +0200")
Message-ID: <yw1x1vsg4jio.fsf@thrashbarg.mansr.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.22 (Instant Classic, linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx> writes:

> On 29.03.2009 13:22 Måns Rullgård wrote:
>> Consider this scenario:
>>
>> 1. Create/write/close newfile
>> 2. Rename newfile to oldfile
>> 3. Open/read oldfile.  This must return the new contents.
>> 4. System crash and reboot before delayed allocation/flush complete
>> 5. Open/read oldfile.  Old contents now returned.
>>
>> This rollback isn't obviously, to me at least, without problems of its
>> own.
>>   
> Having the old data in 5) is far better than having no data in 5).

Of course having old data is better than no data.  However, fsync()
and similar approaches make a rollback to old data after new data has
been visible impossible or far less likely than the suggested one.
I'm not saying it's necessarily a problem, only that it is a
difference that should be taken into account.

-- 
Måns Rullgård
mans@mansr.com
