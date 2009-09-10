Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbZIJO1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbZIJO1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 10:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbZIJO1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 10:27:24 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:65160 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731AbZIJO1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 10:27:23 -0400
MIME-Version: 1.0
In-Reply-To: <87fxaxvuh6.fsf@master.homenet>
References: <87fxaxvuh6.fsf@master.homenet>
Date: Thu, 10 Sep 2009 10:27:25 -0400
Message-ID: <7e0fb38c0909100727t51d3d523o403e05a225881403@mail.gmail.com>
Subject: Re: extend inotify to support file descriptors in addition to paths
From: Eric Paris <eparis@parisplace.org>
To: Giuseppe Scrivano <gscrivano@gnu.org>
Cc: linux-kernel@vger.kernel.org, bug-coreutils@gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 8, 2009 at 8:21 PM, Giuseppe Scrivano <gscrivano@gnu.org> wrote:

> at the moment inotify permits to add new files to be watched using their
> path.  There are situations where the file path is not know but a
> descriptor is available.  It would be desiderable to have the
> possibility to use the inotify system even in these (rare) cases.

I don't think specifying the inode in question by fd is fundamentally
a bad idea.  It is the reason I decided to use fd's when registering
event's in the upcoming fanotify rather than pathnames.  I do however
question if we really want to add yet another syscall for inotify.
We've already seen that inotify is very hard to expand.  The fixed
message length, lack of information a number of users want, and
difficultly in extending those things make me reticent to support more
extentions.

Personally I'd rather see us/you move to fanotify which is (I hope)
extensible forever.  If only I could get networking people to review
it.  Have you looked at fanotify?  I'm going to repost the series in a
couple minutes, maybe you could tell me if fanotify might work for
you?
