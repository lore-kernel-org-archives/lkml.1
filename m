Return-Path: <linux-kernel-owner+w=401wt.eu-S932907AbXA1VhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907AbXA1VhL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 16:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932911AbXA1VhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 16:37:11 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:39372 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932907AbXA1VhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 16:37:10 -0500
Message-ID: <45BD177D.6060907@student.ltu.se>
Date: Sun, 28 Jan 2007 22:37:01 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: akpm@osdl.org
CC: linux-kernel@vger.kernel.org
Subject: [SCRIPT] Remove "space damage" from patches
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew and all

I recently tried "git-apply" on the 2.6.20-rc6-mm1 patch and found it to complain about white-spaces.
So as a mean to (hopefully) cut down on these nasty white-spaces (and sometimes tabs) I wrote this
little script. All it does is checking (lines that are going to be added) for spaces before tabs
and trailing spaces/tabs. I tried it on 2.6.20-rc6-mm1 and it seem to work well

If there is someone interested, _please_ take it. Any suggestion are welcomed :)

Richard Knutsson

--- 

#!/bin/sh

#./<script-name> <patch to check>

msg="Checking..."
echo $msg

while [ "$msg" ]; do \

  msg=""

  if grep -q -E "^\+	* +	" $1; then \
    msg="Found whitespace before tab"
    echo $msg
    sed --in-place -r "s/^\+(	*) {8}( *)	/\+\1	\2	/"	$1
    sed --in-place -r "s/^\+(	*) {1,7}	/\+\1	/"		$1
  fi

  if grep -q -E "^\+.*[	 ]$" $1; then \
    msg="Found trailing whitespace/tab"
    echo $msg
    sed --in-place -r "s/^\+(.*)([^ ])[	 ]+$/\+\1\2/"			$1
    sed --in-place -r "s/^\+[	 ]+$/\+/"				$1
  fi

  if [ "$msg" != "" ]; then \
    echo "Cleaning done, will make another run"
  fi
done


