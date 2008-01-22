Return-Path: <linux-kernel-owner+w=401wt.eu-S1758162AbYAVTOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbYAVTOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 14:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbYAVTO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 14:14:28 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:23320 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799AbYAVTO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 14:14:27 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: konqueror deadlocks on 2.6.22
Date: Tue, 22 Jan 2008 14:13:57 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Ingo Molnar <mingo@elte.hu>,
       Oliver Pinter (=?iso-8859-1?q?Pint=E9r?= =?iso-8859-1?q?_Oliv=E9r?=) 
	<oliver.pntr@gmail.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <200801192114.41427.a1426z@gawab.com> <200801220925.50314.chris.mason@oracle.com> <200801222154.25828.a1426z@gawab.com>
In-Reply-To: <200801222154.25828.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801221413.58337.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2008, Al Boldi wrote:
> Chris Mason wrote:
> > Running fsync in data=ordered means that all of the dirty blocks on the
> > FS will get written before fsync returns.
>
> Hm, that's strange, I expected this kind of behaviour from data=journal.
>
> data=writeback should return immediatly, which seems it does, but
> data=ordered should only wait for metadata flush, it shouldn't wait for
> filedata flush.  Are you sure it waits for both?

I over simplified.  data=ordered means that all data blocks are written before 
the metadata that references them commits.

So, if you add 1GB to a fileA in a transaction and then run fsync(fileB) in 
the same transaction, the 1GB from fileA is sent to disk (and waited on) 
before the fsync on fileB returns.

-chris
