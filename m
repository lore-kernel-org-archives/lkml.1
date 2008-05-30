Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbYE3LBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbYE3LBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 07:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbYE3LBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 07:01:13 -0400
Received: from smtp.nokia.com ([192.100.105.134]:64936 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbYE3LBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 07:01:12 -0400
Message-ID: <483FDDA9.4020401@nokia.com>
Date: Fri, 30 May 2008 13:57:45 +0300
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: UBIFS seekdir()/telldir() issue
References: <483AC0ED.5060805@nokia.com> <20080528154525.GA32634@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20080528154525.GA32634@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 May 2008 11:00:30.0523 (UTC) FILETIME=[600F28B0:01C8C244]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
>   The sequence you write above is actually incorrect I think. Noone
> guarantees that the cookie returned by telldir() is valid after
> closedir(). What is a bigger (and quite common) problem is, if somebody
> uses readdir/telldir/seekdir while someone else creates/deletes files in
> the directory. The standard implies in this case that subsequent
> readdir should return all the files which were not touched (or all files
> after position set by seekdir if used...).

Not according to this:

http://www.opengroup.org/onlinepubs/009695399/functions/readdir.html

	"If a file is removed from or added to the directory after the
	most recent call to opendir() or rewinddir(), whether a
	subsequent call to readdir() returns an entry for that file
	is unspecified."


