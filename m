Return-Path: <linux-kernel-owner+w=401wt.eu-S1763268AbYALHey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763268AbYALHey (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 02:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759732AbYALHeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 02:34:44 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:44347 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011AbYALHen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 02:34:43 -0500
From: Junio C Hamano <gitster@pobox.com>
To: Ismail =?utf-8?Q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.4-rc3
References: <7vsl13wmas.fsf@gitster.siamese.dyndns.org>
	<200801120926.14307.ismail@pardus.org.tr>
Date: Fri, 11 Jan 2008 23:34:34 -0800
In-Reply-To: <200801120926.14307.ismail@pardus.org.tr> (Ismail =?utf-8?Q?D?=
 =?utf-8?Q?=C3=B6nmez's?=
	message of "Sat, 12 Jan 2008 09:26:14 +0200")
Message-ID: <7vejcnwl85.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ismail Dönmez <ismail@pardus.org.tr> writes:

> Saturday 12 January 2008 09:11:23 tarihinde Junio C Hamano şunları yazmıştı:
>> The third rc for the next feature release GIT 1.5.4 is available
>> at the usual places:
>>
>>   http://www.kernel.org/pub/software/scm/git/
>>
>>   git-1.5.4.rc3.tar.{gz,bz2}			(tarball)
>>   git-htmldocs-1.5.4.rc3.tar.{gz,bz2}		(preformatted docs)
>>   git-manpages-1.5.4.rc3.tar.{gz,bz2}		(preformatted docs)
>>   testing/git-*-1.5.4.rc3-1.$arch.rpm	(RPM)
>
> I am seeing new failures compared to rc2 :
>
> *** t9200-git-cvsexportcommit.sh ***
> * FAIL 1: New file
>         mkdir A B C D E F &&
>              echo hello1 >A/newfile1.txt &&
>              echo hello2 >B/newfile2.txt &&
>              cp ../test9200a.png C/newfile3.png &&
>              cp ../test9200a.png D/newfile4.png &&
>              git add A/newfile1.txt &&
>              git add B/newfile2.txt &&
>              git add C/newfile3.png &&
>              git add D/newfile4.png &&
>              git commit -a -m "Test: New file" &&
>              id=$(git rev-list --max-count=1 HEAD) &&
>              (cd "$CVSWORK" &&
>              git cvsexportcommit -c $id &&
>              check_entries A "newfile1.txt/1.1/" &&
>              check_entries B "newfile2.txt/1.1/" &&
>              check_entries C "newfile3.png/1.1/-kb" &&
>              check_entries D "newfile4.png/1.1/-kb" &&
>              diff A/newfile1.txt ../A/newfile1.txt &&
>              diff B/newfile2.txt ../B/newfile2.txt &&
>              diff C/newfile3.png ../C/newfile3.png &&
>              diff D/newfile4.png ../D/newfile4.png
>              )
> Ideas appreciated.

Often the first failure is the most interesting one.  Running
the test under sh -x like this:

	$ cd t
	$ sh t9200-git-cvsexportcommit.sh -i -v

and then looking at "trash" directory would tell you which one
of the long sequence of commands failed, and further
investigation can be made from there.

Thanks.
