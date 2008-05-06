Return-Path: <linux-kernel-owner+w=401wt.eu-S1764648AbYEFRD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764648AbYEFRD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757929AbYEFRDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:03:19 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:6813 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300AbYEFRDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:03:18 -0400
Message-ID: <48208F4F.1030405@de.ibm.com>
Date: Tue, 06 May 2008 19:03:11 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: ltp-list@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>,
       ltp-coverage@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] kbuild: convert include and	source paths
References: <481F26AA.4050701@de.ibm.com> <20080505195815.GD8868@uranus.ravnborg.org>
In-Reply-To: <20080505195815.GD8868@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Mon, May 05, 2008 at 05:24:26PM +0200, Peter Oberparleiter wrote:
>> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
>> 
>> Modify kbuild to convert relative include and source paths to absolute
>> form. Also change the module versioning mechanism to alter object file
>> names only after compiling.
>> 
>> Required by the gcov profiling infrastructure: source paths are
>> referenced by the compiled object files. Using relative paths or
>> object file names which are different from the source name would
>> prevent the gcov tool from finding the corresponding source files.
> 
> For the relative path issue do you really fix this at the right place?
> I would say that teaching gcov tool from where to look would be better.

Actually it is gcc that would need to be changed to only include
absolute paths in compiled object files. While I haven't led that
particular discussion with gcc developers yet, I could imagine that they
would argue that such an option already exists: by specifying only
absolute paths during compilation. Also, any dependency on a future
version of gcc would, in my opinion, greatly reduce the overall
usefulness of this gcov kernel infrastructure.

Would it be acceptable to isolate these changes to kbuild by
if-statements, i.e. use absolute paths only of CONFIG_GCOV is
specified (as Jan Engelhardt suggested)?

>> Also change the module versioning mechanism to alter object file
>> names only after compiling.
> Can I get this as a separate patch please.
> It may be general useful and makes sense to look at alone.

Ok, I will do that.


Regards,
  Peter
