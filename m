Return-Path: <linux-kernel-owner+w=401wt.eu-S933591AbXK2USb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591AbXK2USb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932237AbXK2USV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:18:21 -0500
Received: from rtr.ca ([76.10.145.34]:1643 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760136AbXK2USP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:18:15 -0500
Message-ID: <474F1E6F.2030904@rtr.ca>
Date: Thu, 29 Nov 2007 15:17:51 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] base/class.c: prevent ooops due to
 insert/remove race (v3)
References: <Pine.LNX.4.44L0.0711291510200.5666-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0711291510200.5666-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Thu, 29 Nov 2007, Mark Lord wrote:
> 
>> But the flogging continues multiple times per second
>> until the system is shutdown, so it is "the next bug to fix".
> 
> That's not true.  The number of commands sent while probing a device is
> predetermined and strictly limited.
...

Please tell that to my overflowing syslog (see bottom of this post).
But I hope that 2.6.24 does behave better, thanks.

...
> In any case, what you're talking about is a SCSI issue -- not a USB 
> issue.
...

Absolutely.

[  347.101738] EIP: [strlen+8/17] strlen+0x8/0x11 SS:ESP 0068:f7152e58
[  345.226354] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  345.226360] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  345.226367] sd 7:0:0:0: [sdc] Sense not available.
[  345.226382] sd 7:0:0:0: [sdc] Write Protect is off
[  345.226386] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  345.226390] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  345.226471] sd 7:0:0:0: [sdc] Attached SCSI removable disk
[  345.226539] sd 7:0:0:0: Attached scsi generic sg2 type 0
[  347.151887] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  347.151895] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  347.151902] sd 7:0:0:0: [sdc] Sense not available.
[  347.151918] sd 7:0:0:0: [sdc] Write Protect is off
[  347.151922] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  347.151927] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  347.151981] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  347.151985] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  347.151993] sd 7:0:0:0: [sdc] Sense not available.
[  347.152008] sd 7:0:0:0: [sdc] Write Protect is off
[  347.152013] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  347.152017] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  345.279916] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  345.279951] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  345.279965] sd 7:0:0:0: [sdc] Sense not available.
[  345.279982] sd 7:0:0:0: [sdc] Write Protect is off
[  345.279987] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  345.279991] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  345.280047] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  345.280051] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  345.280059] sd 7:0:0:0: [sdc] Sense not available.
[  345.280075] sd 7:0:0:0: [sdc] Write Protect is off
[  345.280079] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  345.280083] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  345.289528] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  345.289536] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  345.289542] sd 7:0:0:0: [sdc] Sense not available.
[  345.289560] sd 7:0:0:0: [sdc] Write Protect is off
[  345.289564] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  345.289569] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  345.289623] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  345.289627] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  345.289633] sd 7:0:0:0: [sdc] Sense not available.
[  345.289647] sd 7:0:0:0: [sdc] Write Protect is off
[  345.289651] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  345.289654] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  347.299048] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  347.299058] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  347.299065] sd 7:0:0:0: [sdc] Sense not available.
[  347.299082] sd 7:0:0:0: [sdc] Write Protect is off
[  347.299087] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  347.299091] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  347.299148] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  347.299152] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  347.299160] sd 7:0:0:0: [sdc] Sense not available.
[  347.299175] sd 7:0:0:0: [sdc] Write Protect is off
[  347.299180] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  347.299184] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  349.295217] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  349.295227] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  349.295234] sd 7:0:0:0: [sdc] Sense not available.
[  349.295251] sd 7:0:0:0: [sdc] Write Protect is off
[  349.295255] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  349.295259] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  351.171820] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  351.171826] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  351.171834] sd 7:0:0:0: [sdc] Sense not available.
[  351.171850] sd 7:0:0:0: [sdc] Write Protect is off
[  351.171855] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  351.171860] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  353.168992] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  353.169003] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  353.169010] sd 7:0:0:0: [sdc] Sense not available.
[  353.169027] sd 7:0:0:0: [sdc] Write Protect is off
[  353.169031] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  353.169035] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  353.169154] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  353.169159] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  353.169166] sd 7:0:0:0: [sdc] Sense not available.
[  353.169197] sd 7:0:0:0: [sdc] Write Protect is off
[  353.169203] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  353.169207] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  355.165604] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  355.165614] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  355.165621] sd 7:0:0:0: [sdc] Sense not available.
[  355.165684] sd 7:0:0:0: [sdc] Write Protect is off
[  355.165689] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  355.165693] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  355.165755] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  355.165759] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  355.165767] sd 7:0:0:0: [sdc] Sense not available.
[  355.165782] sd 7:0:0:0: [sdc] Write Protect is off
[  355.165787] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  355.165791] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  355.315023] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  355.315032] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  355.315039] sd 7:0:0:0: [sdc] Sense not available.
[  355.315645] sd 7:0:0:0: [sdc] Write Protect is off
[  355.315651] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  355.315655] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  357.192523] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  357.192529] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  357.192537] sd 7:0:0:0: [sdc] Sense not available.
[  357.192565] sd 7:0:0:0: [sdc] Write Protect is off
[  357.192571] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  357.192575] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  359.187957] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  359.187967] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  359.187976] sd 7:0:0:0: [sdc] Sense not available.
[  357.311689] sd 7:0:0:0: [sdc] Write Protect is off
[  357.311695] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  357.311699] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  357.311774] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  357.311778] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  357.311787] sd 7:0:0:0: [sdc] Sense not available.
[  357.311802] sd 7:0:0:0: [sdc] Write Protect is off
[  357.311808] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  357.311812] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  359.308229] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  359.308239] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  359.308246] sd 7:0:0:0: [sdc] Sense not available.
[  359.308263] sd 7:0:0:0: [sdc] Write Protect is off
[  359.308268] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  359.308273] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  361.184759] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  361.184766] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  361.184774] sd 7:0:0:0: [sdc] Sense not available.
[  361.184789] sd 7:0:0:0: [sdc] Write Protect is off
[  361.184795] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  361.184800] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  363.181164] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  363.181172] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  363.181180] sd 7:0:0:0: [sdc] Sense not available.
[  363.181195] sd 7:0:0:0: [sdc] Write Protect is off
[  363.181200] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  363.181204] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  361.304992] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  361.304998] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  361.305018] sd 7:0:0:0: [sdc] Sense not available.
[  361.305061] sd 7:0:0:0: [sdc] Write Protect is off
[  361.305067] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  361.305072] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  363.301409] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  363.301419] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  363.301426] sd 7:0:0:0: [sdc] Sense not available.
[  363.301442] sd 7:0:0:0: [sdc] Write Protect is off
[  363.301448] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  363.301452] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  365.177942] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  365.177948] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  365.177956] sd 7:0:0:0: [sdc] Sense not available.
[  365.177972] sd 7:0:0:0: [sdc] Write Protect is off
[  365.177977] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  365.177981] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  367.174371] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  367.174380] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  367.174387] sd 7:0:0:0: [sdc] Sense not available.
[  367.174404] sd 7:0:0:0: [sdc] Write Protect is off
[  367.174408] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  367.174412] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  367.174547] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  367.174551] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  367.174558] sd 7:0:0:0: [sdc] Sense not available.
[  367.174590] sd 7:0:0:0: [sdc] Write Protect is off
[  367.174594] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  367.174599] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  369.170998] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  369.171007] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  369.171014] sd 7:0:0:0: [sdc] Sense not available.
[  369.171084] sd 7:0:0:0: [sdc] Write Protect is off
[  369.171088] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  369.171093] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  369.171152] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  369.171156] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  369.171164] sd 7:0:0:0: [sdc] Sense not available.
[  369.171179] sd 7:0:0:0: [sdc] Write Protect is off
[  369.171184] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  369.171188] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  371.167564] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  371.167573] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  371.167580] sd 7:0:0:0: [sdc] Sense not available.
[  371.167637] sd 7:0:0:0: [sdc] Write Protect is off
[  371.167642] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  371.167646] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  371.167705] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  371.167710] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  371.167718] sd 7:0:0:0: [sdc] Sense not available.
[  371.167733] sd 7:0:0:0: [sdc] Write Protect is off
[  371.167738] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  371.167742] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  373.164173] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  373.164182] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  373.164190] sd 7:0:0:0: [sdc] Sense not available.
[  373.164206] sd 7:0:0:0: [sdc] Write Protect is off
[  373.164210] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  373.164214] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  371.287983] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  371.287989] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  371.287997] sd 7:0:0:0: [sdc] Sense not available.
[  371.288013] sd 7:0:0:0: [sdc] Write Protect is off
[  371.288019] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  371.288023] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  373.284434] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  373.284443] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  373.284450] sd 7:0:0:0: [sdc] Sense not available.
[  373.284466] sd 7:0:0:0: [sdc] Write Protect is off
[  373.284471] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  373.284475] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  373.284532] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  373.284536] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  373.284543] sd 7:0:0:0: [sdc] Sense not available.
[  373.284559] sd 7:0:0:0: [sdc] Write Protect is off
[  373.284564] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  373.284568] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  375.281084] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  375.281093] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  375.281100] sd 7:0:0:0: [sdc] Sense not available.
[  375.281116] sd 7:0:0:0: [sdc] Write Protect is off
[  375.281121] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  375.281126] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  375.281183] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  375.281187] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  375.281195] sd 7:0:0:0: [sdc] Sense not available.
[  375.281210] sd 7:0:0:0: [sdc] Write Protect is off
[  375.281215] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  375.281219] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  377.277839] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  377.277852] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  377.277860] sd 7:0:0:0: [sdc] Sense not available.
[  377.277914] sd 7:0:0:0: [sdc] Write Protect is off
[  377.277920] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  377.277925] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  377.278104] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  377.278108] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  377.278115] sd 7:0:0:0: [sdc] Sense not available.
[  377.278148] sd 7:0:0:0: [sdc] Write Protect is off
[  377.278152] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  377.278156] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  379.274308] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  379.274318] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  379.274325] sd 7:0:0:0: [sdc] Sense not available.
[  379.274400] sd 7:0:0:0: [sdc] Write Protect is off
[  379.274405] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  379.274409] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  379.274471] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  379.274475] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  379.274483] sd 7:0:0:0: [sdc] Sense not available.
[  379.274498] sd 7:0:0:0: [sdc] Write Protect is off
[  379.274503] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  379.274507] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  381.270917] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  381.270926] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  381.270933] sd 7:0:0:0: [sdc] Sense not available.
[  381.271007] sd 7:0:0:0: [sdc] Write Protect is off
[  381.271012] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  381.271016] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  381.271079] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  381.271083] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  381.271091] sd 7:0:0:0: [sdc] Sense not available.
[  381.271106] sd 7:0:0:0: [sdc] Write Protect is off
[  381.271111] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  381.271115] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  383.267526] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  383.267536] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  383.267543] sd 7:0:0:0: [sdc] Sense not available.
[  383.267559] sd 7:0:0:0: [sdc] Write Protect is off
[  383.267564] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  383.267568] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  385.144007] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  385.144013] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  385.144022] sd 7:0:0:0: [sdc] Sense not available.
[  385.144038] sd 7:0:0:0: [sdc] Write Protect is off
[  385.144043] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  385.144047] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  387.140463] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  387.140472] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  387.140479] sd 7:0:0:0: [sdc] Sense not available.
[  387.140552] sd 7:0:0:0: [sdc] Write Protect is off
[  387.140556] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  387.140561] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  387.140624] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  387.140628] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  387.140636] sd 7:0:0:0: [sdc] Sense not available.
[  387.140651] sd 7:0:0:0: [sdc] Write Protect is off
[  387.140656] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  387.140660] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  386.832769] scsi 2:0:0:0: rejecting I/O to dead device
[  386.832838] FAT: FAT read failed (blocknr 32)
[  389.137083] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  389.137093] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  389.137101] sd 7:0:0:0: [sdc] Sense not available.
[  389.137117] sd 7:0:0:0: [sdc] Write Protect is off
[  389.137123] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  389.137128] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  387.260875] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  387.260882] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  387.260890] sd 7:0:0:0: [sdc] Sense not available.
[  387.260906] sd 7:0:0:0: [sdc] Write Protect is off
[  387.260911] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  387.260916] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  389.257311] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  389.257321] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  389.257328] sd 7:0:0:0: [sdc] Sense not available.
[  389.257344] sd 7:0:0:0: [sdc] Write Protect is off
[  389.257350] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  389.257354] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  389.257412] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  389.257417] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  389.257424] sd 7:0:0:0: [sdc] Sense not available.
[  389.257439] sd 7:0:0:0: [sdc] Write Protect is off
[  389.257444] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  389.257448] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  391.253923] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  391.253931] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  391.253938] sd 7:0:0:0: [sdc] Sense not available.
[  391.253992] sd 7:0:0:0: [sdc] Write Protect is off
[  391.253996] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  391.254000] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  391.254059] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  391.254064] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  391.254071] sd 7:0:0:0: [sdc] Sense not available.
[  391.254087] sd 7:0:0:0: [sdc] Write Protect is off
[  391.254091] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  391.254096] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  393.250538] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  393.250547] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  393.250554] sd 7:0:0:0: [sdc] Sense not available.
[  393.250619] sd 7:0:0:0: [sdc] Write Protect is off
[  393.250623] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  393.250627] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  393.250689] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  393.250693] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  393.250701] sd 7:0:0:0: [sdc] Sense not available.
[  393.250716] sd 7:0:0:0: [sdc] Write Protect is off
[  393.250720] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  393.250725] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  395.247132] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  395.247141] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  395.247148] sd 7:0:0:0: [sdc] Sense not available.
[  395.247206] sd 7:0:0:0: [sdc] Write Protect is off
[  395.247210] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  395.247214] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  395.247273] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  395.247277] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  395.247283] sd 7:0:0:0: [sdc] Sense not available.
[  395.247298] sd 7:0:0:0: [sdc] Write Protect is off
[  395.247302] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  395.247306] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  397.243732] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  397.243741] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  397.243748] sd 7:0:0:0: [sdc] Sense not available.
[  397.243765] sd 7:0:0:0: [sdc] Write Protect is off
[  397.243770] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  397.243774] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  397.243830] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  397.243835] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  397.243843] sd 7:0:0:0: [sdc] Sense not available.
[  397.243858] sd 7:0:0:0: [sdc] Write Protect is off
[  397.243863] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  397.243867] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  399.240360] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  399.240369] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  399.240376] sd 7:0:0:0: [sdc] Sense not available.
[  399.240440] sd 7:0:0:0: [sdc] Write Protect is off
[  399.240444] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  399.240448] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  399.240509] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  399.240513] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  399.240521] sd 7:0:0:0: [sdc] Sense not available.
[  399.240536] sd 7:0:0:0: [sdc] Write Protect is off
[  399.240541] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  399.240546] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  401.236978] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  401.236987] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  401.236994] sd 7:0:0:0: [sdc] Sense not available.
[  401.237061] sd 7:0:0:0: [sdc] Write Protect is off
[  401.237066] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  401.237070] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  401.237131] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  401.237135] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  401.237141] sd 7:0:0:0: [sdc] Sense not available.
[  401.237156] sd 7:0:0:0: [sdc] Write Protect is off
[  401.237160] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  401.237164] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  403.233501] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  403.233506] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  403.233510] sd 7:0:0:0: [sdc] Sense not available.
[  403.233802] sd 7:0:0:0: [sdc] Write Protect is off
[  403.233805] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  403.233807] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  405.110463] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  405.110466] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  405.110469] sd 7:0:0:0: [sdc] Sense not available.
[  405.110476] sd 7:0:0:0: [sdc] Write Protect is off
[  405.110478] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  405.110480] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  407.107317] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  407.107327] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  407.107334] sd 7:0:0:0: [sdc] Sense not available.
[  407.107350] sd 7:0:0:0: [sdc] Write Protect is off
[  407.107354] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  407.107358] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  405.231123] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  405.231128] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  405.231136] sd 7:0:0:0: [sdc] Sense not available.
[  405.231152] sd 7:0:0:0: [sdc] Write Protect is off
[  405.231157] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  405.231162] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  407.226805] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  407.226814] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  407.226821] sd 7:0:0:0: [sdc] Sense not available.
[  407.226886] sd 7:0:0:0: [sdc] Write Protect is off
[  407.226891] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  407.226895] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  407.226954] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  407.226960] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  407.226968] sd 7:0:0:0: [sdc] Sense not available.
[  407.226983] sd 7:0:0:0: [sdc] Write Protect is off
[  407.226988] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  407.226992] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  409.223410] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  409.223420] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  409.223427] sd 7:0:0:0: [sdc] Sense not available.
[  409.223444] sd 7:0:0:0: [sdc] Write Protect is off
[  409.223448] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  409.223453] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  409.223511] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  409.223515] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  409.223523] sd 7:0:0:0: [sdc] Sense not available.
[  409.223538] sd 7:0:0:0: [sdc] Write Protect is off
[  409.223543] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  409.223548] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  411.220018] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  411.220027] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  411.220034] sd 7:0:0:0: [sdc] Sense not available.
[  411.220099] sd 7:0:0:0: [sdc] Write Protect is off
[  411.220104] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  411.220108] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  411.220169] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  411.220174] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  411.220181] sd 7:0:0:0: [sdc] Sense not available.
[  411.220197] sd 7:0:0:0: [sdc] Write Protect is off
[  411.220202] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  411.220206] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  413.216635] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  413.216644] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  413.216652] sd 7:0:0:0: [sdc] Sense not available.
[  413.216668] sd 7:0:0:0: [sdc] Write Protect is off
[  413.216672] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  413.216677] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  415.093128] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  415.093134] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  415.093142] sd 7:0:0:0: [sdc] Sense not available.
[  415.093158] sd 7:0:0:0: [sdc] Write Protect is off
[  415.093163] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  415.093168] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  417.089576] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  417.089586] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  417.089594] sd 7:0:0:0: [sdc] Sense not available.
[  417.089611] sd 7:0:0:0: [sdc] Write Protect is off
[  417.089616] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  417.089621] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  415.213383] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  415.213389] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  415.213397] sd 7:0:0:0: [sdc] Sense not available.
[  415.213413] sd 7:0:0:0: [sdc] Write Protect is off
[  415.213418] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  415.213423] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  417.209791] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  417.209799] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  417.209804] sd 7:0:0:0: [sdc] Sense not available.
[  417.209817] sd 7:0:0:0: [sdc] Write Protect is off
[  417.209821] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  417.209825] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  419.086253] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  419.086257] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  419.086264] sd 7:0:0:0: [sdc] Sense not available.
[  419.086276] sd 7:0:0:0: [sdc] Write Protect is off
[  419.086280] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  419.086283] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  421.082804] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  421.082814] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  421.082821] sd 7:0:0:0: [sdc] Sense not available.
[  421.082837] sd 7:0:0:0: [sdc] Write Protect is off
[  421.082843] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  421.082847] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  419.206609] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  419.206615] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  419.206623] sd 7:0:0:0: [sdc] Sense not available.
[  419.206638] sd 7:0:0:0: [sdc] Write Protect is off
[  419.206644] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  419.206648] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  421.203059] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  421.203068] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  421.203075] sd 7:0:0:0: [sdc] Sense not available.
[  421.203153] sd 7:0:0:0: [sdc] Write Protect is off
[  421.203157] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  421.203161] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  421.203222] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  421.203227] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  421.203234] sd 7:0:0:0: [sdc] Sense not available.
[  421.203249] sd 7:0:0:0: [sdc] Write Protect is off
[  421.203254] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  421.203258] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  423.199627] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  423.199636] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  423.199643] sd 7:0:0:0: [sdc] Sense not available.
[  423.199714] sd 7:0:0:0: [sdc] Write Protect is off
[  423.199719] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  423.199723] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  423.199782] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  423.199787] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  423.199795] sd 7:0:0:0: [sdc] Sense not available.
[  423.199810] sd 7:0:0:0: [sdc] Write Protect is off
[  423.199815] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  423.199820] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  425.196261] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  425.196270] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  425.196277] sd 7:0:0:0: [sdc] Sense not available.
[  425.196351] sd 7:0:0:0: [sdc] Write Protect is off
[  425.196356] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  425.196360] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  425.196422] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  425.196426] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  425.196434] sd 7:0:0:0: [sdc] Sense not available.
[  425.196449] sd 7:0:0:0: [sdc] Write Protect is off
[  425.196454] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  425.196458] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  427.192847] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  427.192856] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  427.192863] sd 7:0:0:0: [sdc] Sense not available.
[  427.192931] sd 7:0:0:0: [sdc] Write Protect is off
[  427.192935] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  427.192939] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  427.192999] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  427.193003] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  427.193012] sd 7:0:0:0: [sdc] Sense not available.
[  427.193027] sd 7:0:0:0: [sdc] Write Protect is off
[  427.193031] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  427.193036] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  429.189478] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  429.189488] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  429.189495] sd 7:0:0:0: [sdc] Sense not available.
[  429.189511] sd 7:0:0:0: [sdc] Write Protect is off
[  429.189515] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  429.189520] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  429.189579] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  429.189583] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  429.189591] sd 7:0:0:0: [sdc] Sense not available.
[  429.189606] sd 7:0:0:0: [sdc] Write Protect is off
[  429.189611] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  429.189615] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  431.186084] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  431.186093] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  431.186101] sd 7:0:0:0: [sdc] Sense not available.
[  431.186174] sd 7:0:0:0: [sdc] Write Protect is off
[  431.186178] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  431.186182] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  431.186244] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  431.186247] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  431.186256] sd 7:0:0:0: [sdc] Sense not available.
[  431.186270] sd 7:0:0:0: [sdc] Write Protect is off
[  431.186275] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  431.186280] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  433.182692] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  433.182701] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  433.182708] sd 7:0:0:0: [sdc] Sense not available.
[  433.182782] sd 7:0:0:0: [sdc] Write Protect is off
[  433.182786] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  433.182790] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  433.182853] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  433.182857] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  433.182865] sd 7:0:0:0: [sdc] Sense not available.
[  433.182880] sd 7:0:0:0: [sdc] Write Protect is off
[  433.182885] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  433.182889] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  435.179299] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  435.179309] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  435.179316] sd 7:0:0:0: [sdc] Sense not available.
[  435.179332] sd 7:0:0:0: [sdc] Write Protect is off
[  435.179336] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  435.179342] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  437.055781] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  437.055788] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  437.055795] sd 7:0:0:0: [sdc] Sense not available.
[  437.055811] sd 7:0:0:0: [sdc] Write Protect is off
[  437.055816] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  437.055821] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  439.052231] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  439.052241] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  439.052248] sd 7:0:0:0: [sdc] Sense not available.
[  439.052313] sd 7:0:0:0: [sdc] Write Protect is off
[  439.052318] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  439.052322] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  439.052383] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  439.052387] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  439.052394] sd 7:0:0:0: [sdc] Sense not available.
[  439.052410] sd 7:0:0:0: [sdc] Write Protect is off
[  439.052414] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  439.052419] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  441.049683] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  441.049693] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  441.049700] sd 7:0:0:0: [sdc] Sense not available.
[  441.049717] sd 7:0:0:0: [sdc] Write Protect is off
[  441.049721] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  441.049726] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  439.173492] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  439.173498] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  439.173506] sd 7:0:0:0: [sdc] Sense not available.
[  439.173522] sd 7:0:0:0: [sdc] Write Protect is off
[  439.173526] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  439.173531] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  441.169098] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  441.169108] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  441.169115] sd 7:0:0:0: [sdc] Sense not available.
[  441.169182] sd 7:0:0:0: [sdc] Write Protect is off
[  441.169187] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  441.169191] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  441.169251] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  441.169255] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  441.169264] sd 7:0:0:0: [sdc] Sense not available.
[  441.169279] sd 7:0:0:0: [sdc] Write Protect is off
[  441.169284] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  441.169288] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  443.168959] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  443.168965] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  443.168969] sd 7:0:0:0: [sdc] Sense not available.
[  443.168977] sd 7:0:0:0: [sdc] Write Protect is off
[  443.168979] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  443.168981] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  443.169059] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  443.169061] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  443.169064] sd 7:0:0:0: [sdc] Sense not available.
[  443.169079] sd 7:0:0:0: [sdc] Write Protect is off
[  443.169081] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  443.169083] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  445.165624] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  445.165634] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  445.165641] sd 7:0:0:0: [sdc] Sense not available.
[  445.166489] sd 7:0:0:0: [sdc] Write Protect is off
[  445.166496] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  445.166500] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  445.167248] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  445.167253] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  445.167258] sd 7:0:0:0: [sdc] Sense not available.
[  445.168012] sd 7:0:0:0: [sdc] Write Protect is off
[  445.168018] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  445.168021] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  447.162240] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  447.162249] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  447.162256] sd 7:0:0:0: [sdc] Sense not available.
[  447.163090] sd 7:0:0:0: [sdc] Write Protect is off
[  447.163096] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  447.163100] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  447.163838] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  447.163843] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  447.163849] sd 7:0:0:0: [sdc] Sense not available.
[  447.164596] sd 7:0:0:0: [sdc] Write Protect is off
[  447.164602] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  447.164605] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  449.158856] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  449.158865] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  449.158872] sd 7:0:0:0: [sdc] Sense not available.
[  449.159725] sd 7:0:0:0: [sdc] Write Protect is off
[  449.159731] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  449.159735] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  449.160489] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  449.160495] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  449.160501] sd 7:0:0:0: [sdc] Sense not available.
[  449.161406] sd 7:0:0:0: [sdc] Write Protect is off
[  449.161412] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  449.161416] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  451.158822] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  451.158830] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  451.158838] sd 7:0:0:0: [sdc] Sense not available.
[  451.159671] sd 7:0:0:0: [sdc] Write Protect is off
[  451.159678] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  451.159682] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  451.160421] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  451.160426] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  451.160432] sd 7:0:0:0: [sdc] Sense not available.
[  451.161178] sd 7:0:0:0: [sdc] Write Protect is off
[  451.161184] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  451.161188] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  453.155431] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  453.155440] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  453.155447] sd 7:0:0:0: [sdc] Sense not available.
[  453.156288] sd 7:0:0:0: [sdc] Write Protect is off
[  453.156295] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  453.156299] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  453.157037] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  453.157042] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  453.157048] sd 7:0:0:0: [sdc] Sense not available.
[  453.157795] sd 7:0:0:0: [sdc] Write Protect is off
[  453.157800] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  453.157804] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  455.152083] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  455.152092] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  455.152100] sd 7:0:0:0: [sdc] Sense not available.
[  455.152963] sd 7:0:0:0: [sdc] Write Protect is off
[  455.152970] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  455.152974] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  455.153751] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  455.153757] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  455.153764] sd 7:0:0:0: [sdc] Sense not available.
[  455.154546] sd 7:0:0:0: [sdc] Write Protect is off
[  455.154553] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  455.154556] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  459.028310] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  459.028321] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  459.028328] sd 7:0:0:0: [sdc] Sense not available.
[  459.028345] sd 7:0:0:0: [sdc] Write Protect is off
[  459.028349] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  459.028354] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  459.028412] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  459.028416] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  459.028423] sd 7:0:0:0: [sdc] Sense not available.
[  459.028439] sd 7:0:0:0: [sdc] Write Protect is off
[  459.028443] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  459.028448] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  461.024921] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  461.024931] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  461.024939] sd 7:0:0:0: [sdc] Sense not available.
[  461.024955] sd 7:0:0:0: [sdc] Write Protect is off
[  461.024959] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  461.024964] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  459.148717] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  459.148723] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  459.148731] sd 7:0:0:0: [sdc] Sense not available.
[  459.148747] sd 7:0:0:0: [sdc] Write Protect is off
[  459.148752] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  459.148757] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  461.145147] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  461.145155] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  461.145163] sd 7:0:0:0: [sdc] Sense not available.
[  461.145221] sd 7:0:0:0: [sdc] Write Protect is off
[  461.145225] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  461.145229] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  461.145518] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  461.145521] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  461.145527] sd 7:0:0:0: [sdc] Sense not available.
[  461.145642] sd 7:0:0:0: [sdc] Write Protect is off
[  461.145646] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  461.145650] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  463.141788] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  463.141797] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  463.141805] sd 7:0:0:0: [sdc] Sense not available.
[  463.141868] sd 7:0:0:0: [sdc] Write Protect is off
[  463.141873] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  463.141877] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  463.141937] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  463.141942] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  463.141950] sd 7:0:0:0: [sdc] Sense not available.
[  463.141966] sd 7:0:0:0: [sdc] Write Protect is off
[  463.141971] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  463.141975] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  465.138396] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  465.138405] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  465.138413] sd 7:0:0:0: [sdc] Sense not available.
[  465.138428] sd 7:0:0:0: [sdc] Write Protect is off
[  465.138433] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  465.138438] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  465.138498] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  465.138502] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  465.138509] sd 7:0:0:0: [sdc] Sense not available.
[  465.138525] sd 7:0:0:0: [sdc] Write Protect is off
[  465.138529] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  465.138534] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  467.135833] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  467.135843] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  467.135851] sd 7:0:0:0: [sdc] Sense not available.
[  467.135867] sd 7:0:0:0: [sdc] Write Protect is off
[  467.135872] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  467.135876] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  467.135935] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  467.135938] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  467.135947] sd 7:0:0:0: [sdc] Sense not available.
[  467.135962] sd 7:0:0:0: [sdc] Write Protect is off
[  467.135966] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  467.135971] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  469.131572] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  469.131580] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  469.131588] sd 7:0:0:0: [sdc] Sense not available.
[  469.131603] sd 7:0:0:0: [sdc] Write Protect is off
[  469.131608] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  469.131612] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  469.131776] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  469.131781] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  469.131789] sd 7:0:0:0: [sdc] Sense not available.
[  469.131812] sd 7:0:0:0: [sdc] Write Protect is off
[  469.131817] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  469.131821] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  471.128220] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  471.128229] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  471.128236] sd 7:0:0:0: [sdc] Sense not available.
[  471.128294] sd 7:0:0:0: [sdc] Write Protect is off
[  471.128299] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  471.128303] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  471.128363] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  471.128368] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  471.128375] sd 7:0:0:0: [sdc] Sense not available.
[  471.128392] sd 7:0:0:0: [sdc] Write Protect is off
[  471.128397] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  471.128401] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  473.124806] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  473.124814] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  473.124822] sd 7:0:0:0: [sdc] Sense not available.
[  473.124838] sd 7:0:0:0: [sdc] Write Protect is off
[  473.124843] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  473.124847] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  475.001303] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  475.001309] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  475.001317] sd 7:0:0:0: [sdc] Sense not available.
[  475.001333] sd 7:0:0:0: [sdc] Write Protect is off
[  475.001338] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  475.001342] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  476.997786] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  476.997796] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  476.997803] sd 7:0:0:0: [sdc] Sense not available.
[  476.997877] sd 7:0:0:0: [sdc] Write Protect is off
[  476.997882] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  476.997886] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  476.997948] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  476.997952] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  476.997961] sd 7:0:0:0: [sdc] Sense not available.
[  476.997976] sd 7:0:0:0: [sdc] Write Protect is off
[  476.997980] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  476.997985] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  478.994390] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  478.994400] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  478.994407] sd 7:0:0:0: [sdc] Sense not available.
[  478.994475] sd 7:0:0:0: [sdc] Write Protect is off
[  478.994480] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  478.994484] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  478.994545] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  478.994550] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  478.994558] sd 7:0:0:0: [sdc] Sense not available.
[  478.994573] sd 7:0:0:0: [sdc] Write Protect is off
[  478.994578] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  478.994582] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  480.991764] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  480.991773] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  480.991780] sd 7:0:0:0: [sdc] Sense not available.
[  480.991841] sd 7:0:0:0: [sdc] Write Protect is off
[  480.991846] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  480.991850] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  480.991909] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  480.991913] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  480.991920] sd 7:0:0:0: [sdc] Sense not available.
[  480.991936] sd 7:0:0:0: [sdc] Write Protect is off
[  480.991941] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  480.991945] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  482.987627] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  482.987637] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  482.987644] sd 7:0:0:0: [sdc] Sense not available.
[  481.111936] sd 7:0:0:0: [sdc] Write Protect is off
[  481.111943] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  481.111947] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  481.112023] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  481.112027] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  481.112035] sd 7:0:0:0: [sdc] Sense not available.
[  481.112051] sd 7:0:0:0: [sdc] Write Protect is off
[  481.112056] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  481.112060] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  483.107876] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  483.107885] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  483.107892] sd 7:0:0:0: [sdc] Sense not available.
[  483.108493] sd 7:0:0:0: [sdc] Write Protect is off
[  483.108500] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  483.108504] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  483.108815] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  483.108819] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  483.108825] sd 7:0:0:0: [sdc] Sense not available.
[  483.108840] sd 7:0:0:0: [sdc] Write Protect is off
[  483.108845] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  483.108848] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  485.104483] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  485.104493] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  485.104500] sd 7:0:0:0: [sdc] Sense not available.
[  485.104516] sd 7:0:0:0: [sdc] Write Protect is off
[  485.104521] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  485.104526] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  485.104584] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  485.104589] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  485.104597] sd 7:0:0:0: [sdc] Sense not available.
[  485.104612] sd 7:0:0:0: [sdc] Write Protect is off
[  485.104616] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  485.104621] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  487.101090] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  487.101100] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  487.101107] sd 7:0:0:0: [sdc] Sense not available.
[  487.101124] sd 7:0:0:0: [sdc] Write Protect is off
[  487.101128] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  487.101133] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  487.101192] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  487.101197] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  487.101204] sd 7:0:0:0: [sdc] Sense not available.
[  487.101219] sd 7:0:0:0: [sdc] Write Protect is off
[  487.101224] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  487.101228] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  489.098516] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  489.098526] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  489.098533] sd 7:0:0:0: [sdc] Sense not available.
[  489.098550] sd 7:0:0:0: [sdc] Write Protect is off
[  489.098555] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  489.098559] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  489.098617] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  489.098621] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  489.098628] sd 7:0:0:0: [sdc] Sense not available.
[  489.098644] sd 7:0:0:0: [sdc] Write Protect is off
[  489.098648] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  489.098653] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  491.094283] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  491.094293] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  491.094300] sd 7:0:0:0: [sdc] Sense not available.
[  491.094370] sd 7:0:0:0: [sdc] Write Protect is off
[  491.094374] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  491.094379] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  491.094438] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  491.094442] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  491.094450] sd 7:0:0:0: [sdc] Sense not available.
[  491.094465] sd 7:0:0:0: [sdc] Write Protect is off
[  491.094470] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  491.094474] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  493.090905] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  493.090914] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  493.090921] sd 7:0:0:0: [sdc] Sense not available.
[  493.090986] sd 7:0:0:0: [sdc] Write Protect is off
[  493.090990] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  493.090995] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  493.091055] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  493.091059] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  493.091067] sd 7:0:0:0: [sdc] Sense not available.
[  493.091082] sd 7:0:0:0: [sdc] Write Protect is off
[  493.091087] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  493.091091] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  495.087521] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  495.087531] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  495.087538] sd 7:0:0:0: [sdc] Sense not available.
[  495.087555] sd 7:0:0:0: [sdc] Write Protect is off
[  495.087559] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  495.087564] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  495.087622] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  495.087627] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  495.087636] sd 7:0:0:0: [sdc] Sense not available.
[  495.087651] sd 7:0:0:0: [sdc] Write Protect is off
[  495.087656] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  495.087660] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  497.084129] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  497.084138] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  497.084145] sd 7:0:0:0: [sdc] Sense not available.
[  497.084210] sd 7:0:0:0: [sdc] Write Protect is off
[  497.084214] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  497.084218] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  497.084279] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  497.084283] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  497.084291] sd 7:0:0:0: [sdc] Sense not available.
[  497.084306] sd 7:0:0:0: [sdc] Write Protect is off
[  497.084311] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  497.084315] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  499.080723] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  499.080733] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  499.080741] sd 7:0:0:0: [sdc] Sense not available.
[  499.080765] sd 7:0:0:0: [sdc] Write Protect is off
[  499.080769] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  499.080773] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  499.080832] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  499.080836] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  499.080844] sd 7:0:0:0: [sdc] Sense not available.
[  499.080859] sd 7:0:0:0: [sdc] Write Protect is off
[  499.080864] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  499.080868] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  501.077334] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  501.077343] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  501.077351] sd 7:0:0:0: [sdc] Sense not available.
[  501.077957] sd 7:0:0:0: [sdc] Write Protect is off
[  501.077963] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  501.077967] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  501.078317] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  501.078320] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  501.078326] sd 7:0:0:0: [sdc] Sense not available.
[  501.078340] sd 7:0:0:0: [sdc] Write Protect is off
[  501.078344] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  501.078347] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  503.073942] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  503.073951] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  503.073959] sd 7:0:0:0: [sdc] Sense not available.
[  503.074025] sd 7:0:0:0: [sdc] Write Protect is off
[  503.074029] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  503.074033] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  503.074094] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  503.074098] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  503.074105] sd 7:0:0:0: [sdc] Sense not available.
[  503.074121] sd 7:0:0:0: [sdc] Write Protect is off
[  503.074125] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  503.074130] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  505.070531] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  505.070540] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  505.070547] sd 7:0:0:0: [sdc] Sense not available.
[  505.070605] sd 7:0:0:0: [sdc] Write Protect is off
[  505.070610] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  505.070613] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  505.070673] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  505.070677] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  505.070685] sd 7:0:0:0: [sdc] Sense not available.
[  505.070700] sd 7:0:0:0: [sdc] Write Protect is off
[  505.070705] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  505.070709] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  507.067139] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  507.067149] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  507.067156] sd 7:0:0:0: [sdc] Sense not available.
[  507.067173] sd 7:0:0:0: [sdc] Write Protect is off
[  507.067178] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  507.067182] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  507.067239] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  507.067243] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  507.067252] sd 7:0:0:0: [sdc] Sense not available.
[  507.067267] sd 7:0:0:0: [sdc] Write Protect is off
[  507.067271] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  507.067276] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  509.063771] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  509.063779] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  509.063787] sd 7:0:0:0: [sdc] Sense not available.
[  509.063844] sd 7:0:0:0: [sdc] Write Protect is off
[  509.063849] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  509.063853] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  509.063915] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  509.063919] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  509.063927] sd 7:0:0:0: [sdc] Sense not available.
[  509.063941] sd 7:0:0:0: [sdc] Write Protect is off
[  509.063946] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  509.063951] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  511.060356] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  511.060364] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  511.060372] sd 7:0:0:0: [sdc] Sense not available.
[  511.060965] sd 7:0:0:0: [sdc] Write Protect is off
[  511.060971] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  511.060975] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  511.061283] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  511.061287] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  511.061293] sd 7:0:0:0: [sdc] Sense not available.
[  511.061350] sd 7:0:0:0: [sdc] Write Protect is off
[  511.061354] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  511.061358] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  513.056979] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  513.056989] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  513.056996] sd 7:0:0:0: [sdc] Sense not available.
[  513.057058] sd 7:0:0:0: [sdc] Write Protect is off
[  513.057063] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  513.057067] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  513.057127] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  513.057132] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  513.057139] sd 7:0:0:0: [sdc] Sense not available.
[  513.057155] sd 7:0:0:0: [sdc] Write Protect is off
[  513.057161] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  513.057165] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  515.053571] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  515.053580] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  515.053587] sd 7:0:0:0: [sdc] Sense not available.
[  515.053645] sd 7:0:0:0: [sdc] Write Protect is off
[  515.053649] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  515.053653] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  515.053713] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  515.053717] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  515.053725] sd 7:0:0:0: [sdc] Sense not available.
[  515.053740] sd 7:0:0:0: [sdc] Write Protect is off
[  515.053745] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  515.053749] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  517.050198] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  517.050207] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  517.050214] sd 7:0:0:0: [sdc] Sense not available.
[  517.050278] sd 7:0:0:0: [sdc] Write Protect is off
[  517.050283] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  517.050287] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  517.050348] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  517.050353] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  517.050360] sd 7:0:0:0: [sdc] Sense not available.
[  517.050375] sd 7:0:0:0: [sdc] Write Protect is off
[  517.050380] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  517.050384] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  519.046814] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  519.046823] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  519.046830] sd 7:0:0:0: [sdc] Sense not available.
[  519.046904] sd 7:0:0:0: [sdc] Write Protect is off
[  519.046908] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  519.046912] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  519.046973] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  519.046977] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  519.046985] sd 7:0:0:0: [sdc] Sense not available.
[  519.047000] sd 7:0:0:0: [sdc] Write Protect is off
[  519.047005] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  519.047009] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  521.043421] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  521.043430] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  521.043437] sd 7:0:0:0: [sdc] Sense not available.
[  521.043503] sd 7:0:0:0: [sdc] Write Protect is off
[  521.043507] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  521.043511] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  521.043574] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  521.043578] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  521.043586] sd 7:0:0:0: [sdc] Sense not available.
[  521.043601] sd 7:0:0:0: [sdc] Write Protect is off
[  521.043606] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  521.043610] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  523.040011] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  523.040021] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  523.040028] sd 7:0:0:0: [sdc] Sense not available.
[  523.040045] sd 7:0:0:0: [sdc] Write Protect is off
[  523.040050] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  523.040054] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  523.040111] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  523.040115] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  523.040122] sd 7:0:0:0: [sdc] Sense not available.
[  523.040138] sd 7:0:0:0: [sdc] Write Protect is off
[  523.040142] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  523.040147] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  525.036609] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  525.036619] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  525.036626] sd 7:0:0:0: [sdc] Sense not available.
[  525.036642] sd 7:0:0:0: [sdc] Write Protect is off
[  525.036648] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  525.036652] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  525.036709] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  525.036713] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  525.036720] sd 7:0:0:0: [sdc] Sense not available.
[  525.036735] sd 7:0:0:0: [sdc] Write Protect is off
[  525.036740] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  525.036744] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  527.033220] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  527.033230] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  527.033237] sd 7:0:0:0: [sdc] Sense not available.
[  527.033296] sd 7:0:0:0: [sdc] Write Protect is off
[  527.033300] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  527.033304] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  527.033364] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  527.033368] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  527.033375] sd 7:0:0:0: [sdc] Sense not available.
[  527.033390] sd 7:0:0:0: [sdc] Write Protect is off
[  527.033395] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  527.033399] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  529.029840] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  529.029850] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  529.029857] sd 7:0:0:0: [sdc] Sense not available.
[  529.029873] sd 7:0:0:0: [sdc] Write Protect is off
[  529.029879] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  529.029883] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  529.029942] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  529.029946] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  529.029954] sd 7:0:0:0: [sdc] Sense not available.
[  529.029969] sd 7:0:0:0: [sdc] Write Protect is off
[  529.029974] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  529.029978] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  531.026416] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  531.026425] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  531.026432] sd 7:0:0:0: [sdc] Sense not available.
[  531.026491] sd 7:0:0:0: [sdc] Write Protect is off
[  531.026495] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  531.026499] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  531.026557] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  531.026561] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  531.026569] sd 7:0:0:0: [sdc] Sense not available.
[  531.026584] sd 7:0:0:0: [sdc] Write Protect is off
[  531.026589] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  531.026593] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  533.022994] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  533.023004] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  533.023011] sd 7:0:0:0: [sdc] Sense not available.
[  534.899399] sd 7:0:0:0: [sdc] Write Protect is off
[  534.899405] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  534.899409] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  534.899480] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  534.899484] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  534.899492] sd 7:0:0:0: [sdc] Sense not available.
[  534.899508] sd 7:0:0:0: [sdc] Write Protect is off
[  534.899513] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  534.899517] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  536.896810] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  536.896820] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  536.896828] sd 7:0:0:0: [sdc] Sense not available.
[  536.896886] sd 7:0:0:0: [sdc] Write Protect is off
[  536.896890] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  536.896894] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  536.896953] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  536.896956] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  536.896963] sd 7:0:0:0: [sdc] Sense not available.
[  536.896977] sd 7:0:0:0: [sdc] Write Protect is off
[  536.896981] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  536.896985] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  538.893412] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  538.893422] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  538.893429] sd 7:0:0:0: [sdc] Sense not available.
[  538.893445] sd 7:0:0:0: [sdc] Write Protect is off
[  538.893450] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  538.893454] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  538.893510] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  538.893514] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  538.893521] sd 7:0:0:0: [sdc] Sense not available.
[  538.893536] sd 7:0:0:0: [sdc] Write Protect is off
[  538.893541] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  538.893546] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  540.889951] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  540.889956] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  540.889960] sd 7:0:0:0: [sdc] Sense not available.
[  540.889968] sd 7:0:0:0: [sdc] Write Protect is off
[  540.889970] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  540.889974] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  540.890063] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  540.890066] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  540.890070] sd 7:0:0:0: [sdc] Sense not available.
[  540.890093] sd 7:0:0:0: [sdc] Write Protect is off
[  540.890096] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  540.890098] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  542.885840] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  542.885850] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  542.885857] sd 7:0:0:0: [sdc] Sense not available.
[  542.885924] sd 7:0:0:0: [sdc] Write Protect is off
[  542.885929] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  542.885933] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  542.885996] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  542.886000] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  542.886008] sd 7:0:0:0: [sdc] Sense not available.
[  542.886024] sd 7:0:0:0: [sdc] Write Protect is off
[  542.886029] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  542.886034] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  544.883215] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  544.883224] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  544.883232] sd 7:0:0:0: [sdc] Sense not available.
[  544.883274] sd 7:0:0:0: [sdc] Write Protect is off
[  544.883279] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  544.883284] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  544.883441] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  544.883446] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  544.883453] sd 7:0:0:0: [sdc] Sense not available.
[  544.883491] sd 7:0:0:0: [sdc] Write Protect is off
[  544.883495] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  544.883499] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  546.879833] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  546.879842] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  546.879849] sd 7:0:0:0: [sdc] Sense not available.
[  546.879910] sd 7:0:0:0: [sdc] Write Protect is off
[  546.879914] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  546.879918] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  546.880164] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  546.880167] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  546.880173] sd 7:0:0:0: [sdc] Sense not available.
[  546.880241] sd 7:0:0:0: [sdc] Write Protect is off
[  546.880245] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  546.880249] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  548.876444] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  548.876453] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  548.876461] sd 7:0:0:0: [sdc] Sense not available.
[  548.876527] sd 7:0:0:0: [sdc] Write Protect is off
[  548.876532] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  548.876537] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  548.876677] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  548.876681] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  548.876689] sd 7:0:0:0: [sdc] Sense not available.
[  548.876717] sd 7:0:0:0: [sdc] Write Protect is off
[  548.876721] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  548.876726] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  550.873049] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  550.873059] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  550.873066] sd 7:0:0:0: [sdc] Sense not available.
[  548.996757] sd 7:0:0:0: [sdc] Write Protect is off
[  548.996763] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  548.996767] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  548.996835] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  548.996839] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  548.996847] sd 7:0:0:0: [sdc] Sense not available.
[  548.996867] sd 7:0:0:0: [sdc] Write Protect is off
[  548.996869] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  548.996872] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  550.995832] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  550.995842] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  550.995849] sd 7:0:0:0: [sdc] Sense not available.
[  550.995865] sd 7:0:0:0: [sdc] Write Protect is off
[  550.995869] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  550.995873] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  552.872354] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  552.872360] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  552.872368] sd 7:0:0:0: [sdc] Sense not available.
[  552.872384] sd 7:0:0:0: [sdc] Write Protect is off
[  552.872389] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  552.872394] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  554.869569] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  554.869578] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  554.869585] sd 7:0:0:0: [sdc] Sense not available.
[  554.869632] sd 7:0:0:0: [sdc] Write Protect is off
[  554.869637] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  554.869641] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  554.869968] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  554.869971] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  554.869977] sd 7:0:0:0: [sdc] Sense not available.
[  554.870093] sd 7:0:0:0: [sdc] Write Protect is off
[  554.870097] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  554.870100] sd 7:0:0:0: [sdc] Assuming drive cache: write through
7]: synchronized to 10.0.0.2, stratum 3
[  556.866204] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  556.866213] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  556.866221] sd 7:0:0:0: [sdc] Sense not available.
[  556.866237] sd 7:0:0:0: [sdc] Write Protect is off
[  556.866241] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  556.866245] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  556.866413] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  556.866417] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  556.866425] sd 7:0:0:0: [sdc] Sense not available.
[  556.866454] sd 7:0:0:0: [sdc] Write Protect is off
[  556.866459] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  556.866463] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  558.862767] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  558.862772] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  558.862776] sd 7:0:0:0: [sdc] Sense not available.
[  558.862817] sd 7:0:0:0: [sdc] Write Protect is off
[  558.862819] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  558.862821] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  558.862849] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  558.862851] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  558.862855] sd 7:0:0:0: [sdc] Sense not available.
[  558.862863] sd 7:0:0:0: [sdc] Write Protect is off
[  558.862865] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  558.862868] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  560.859445] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  560.859454] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  560.859463] sd 7:0:0:0: [sdc] Sense not available.
[  560.859513] sd 7:0:0:0: [sdc] Write Protect is off
[  560.859518] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  560.859523] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  560.859676] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  560.859680] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  560.859688] sd 7:0:0:0: [sdc] Sense not available.
[  560.859720] sd 7:0:0:0: [sdc] Write Protect is off
[  560.859726] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  560.859730] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  562.855251] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  562.855260] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  562.855267] sd 7:0:0:0: [sdc] Sense not available.
[  562.855307] sd 7:0:0:0: [sdc] Write Protect is off
[  562.855311] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  562.855315] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  562.855375] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  562.855379] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  562.855388] sd 7:0:0:0: [sdc] Sense not available.
[  562.855403] sd 7:0:0:0: [sdc] Write Protect is off
[  562.855408] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  562.855413] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  564.852667] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  564.852676] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  564.852683] sd 7:0:0:0: [sdc] Sense not available.
[  564.852734] sd 7:0:0:0: [sdc] Write Protect is off
[  564.852738] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  564.852742] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  564.853062] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  564.853065] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  564.853071] sd 7:0:0:0: [sdc] Sense not available.
[  564.853185] sd 7:0:0:0: [sdc] Write Protect is off
[  564.853189] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  564.853192] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  566.849436] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  566.849441] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  566.849444] sd 7:0:0:0: [sdc] Sense not available.
[  566.849472] sd 7:0:0:0: [sdc] Write Protect is off
[  566.849474] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  566.849476] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  566.849572] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  566.849574] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  566.849577] sd 7:0:0:0: [sdc] Sense not available.
[  566.849592] sd 7:0:0:0: [sdc] Write Protect is off
[  566.849593] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  566.849595] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  568.845906] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  568.845915] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  568.845922] sd 7:0:0:0: [sdc] Sense not available.
[  568.845974] sd 7:0:0:0: [sdc] Write Protect is off
[  568.845979] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  568.845983] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  566.969726] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  566.969752] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  566.969760] sd 7:0:0:0: [sdc] Sense not available.
[  566.969783] sd 7:0:0:0: [sdc] Write Protect is off
[  566.969788] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  566.969793] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  568.965345] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  568.965354] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  568.965362] sd 7:0:0:0: [sdc] Sense not available.
[  568.965424] sd 7:0:0:0: [sdc] Write Protect is off
[  568.965428] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  568.965432] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  568.965491] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  568.965495] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  568.965503] sd 7:0:0:0: [sdc] Sense not available.
[  568.965519] sd 7:0:0:0: [sdc] Write Protect is off
[  568.965523] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  568.965528] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  570.962015] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  570.962025] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  570.962032] sd 7:0:0:0: [sdc] Sense not available.
[  570.962049] sd 7:0:0:0: [sdc] Write Protect is off
[  570.962053] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  570.962058] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  572.838509] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  572.838515] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  572.838523] sd 7:0:0:0: [sdc] Sense not available.
[  572.838539] sd 7:0:0:0: [sdc] Write Protect is off
[  572.838544] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  572.838549] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  574.835757] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  574.835768] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  574.835776] sd 7:0:0:0: [sdc] Sense not available.
[  574.835808] sd 7:0:0:0: [sdc] Write Protect is off
[  574.835814] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  574.835819] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  572.959563] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  572.959588] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  572.959596] sd 7:0:0:0: [sdc] Sense not available.
[  572.959612] sd 7:0:0:0: [sdc] Write Protect is off
[  572.959618] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  572.959622] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  574.955212] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  574.955220] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  574.955228] sd 7:0:0:0: [sdc] Sense not available.
[  574.955294] sd 7:0:0:0: [sdc] Write Protect is off
[  574.955298] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  574.955302] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  574.955362] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  574.955366] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  574.955374] sd 7:0:0:0: [sdc] Sense not available.
[  574.955388] sd 7:0:0:0: [sdc] Write Protect is off
[  574.955393] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  574.955398] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  576.951873] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  576.951883] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  576.951890] sd 7:0:0:0: [sdc] Sense not available.
[  576.951907] sd 7:0:0:0: [sdc] Write Protect is off
[  576.951911] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  576.951915] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  578.828386] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  578.828391] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  578.828400] sd 7:0:0:0: [sdc] Sense not available.
[  578.828416] sd 7:0:0:0: [sdc] Write Protect is off
[  578.828421] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  578.828426] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  580.824843] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  580.824852] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  580.824859] sd 7:0:0:0: [sdc] Sense not available.
[  580.824924] sd 7:0:0:0: [sdc] Write Protect is off
[  580.824928] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  580.824932] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  580.824994] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  580.824999] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  580.825006] sd 7:0:0:0: [sdc] Sense not available.
[  580.825021] sd 7:0:0:0: [sdc] Write Protect is off
[  580.825026] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  580.825031] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  582.821464] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  582.821473] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  582.821480] sd 7:0:0:0: [sdc] Sense not available.
[  582.821537] sd 7:0:0:0: [sdc] Write Protect is off
[  582.821541] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  582.821545] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  582.821607] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  582.821611] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  582.821619] sd 7:0:0:0: [sdc] Sense not available.
[  582.821635] sd 7:0:0:0: [sdc] Write Protect is off
[  582.821639] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  582.821644] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  584.818084] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  584.818094] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  584.818101] sd 7:0:0:0: [sdc] Sense not available.
[  584.818159] sd 7:0:0:0: [sdc] Write Protect is off
[  584.818163] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  584.818167] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  584.818229] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  584.818233] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  584.818240] sd 7:0:0:0: [sdc] Sense not available.
[  584.818256] sd 7:0:0:0: [sdc] Write Protect is off
[  584.818261] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  584.818265] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  586.815512] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  586.815522] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  586.815529] sd 7:0:0:0: [sdc] Sense not available.
[  586.815546] sd 7:0:0:0: [sdc] Write Protect is off
[  586.815550] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  586.815554] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  584.939361] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  584.939368] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  584.939376] sd 7:0:0:0: [sdc] Sense not available.
[  584.939392] sd 7:0:0:0: [sdc] Write Protect is off
[  584.939397] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  584.939401] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  586.934995] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  586.935004] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  586.935011] sd 7:0:0:0: [sdc] Sense not available.
[  586.935085] sd 7:0:0:0: [sdc] Write Protect is off
[  586.935089] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  586.935093] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  586.935156] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  586.935160] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  586.935168] sd 7:0:0:0: [sdc] Sense not available.
[  586.935183] sd 7:0:0:0: [sdc] Write Protect is off
[  586.935188] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  586.935192] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  588.931539] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  588.931548] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  588.931555] sd 7:0:0:0: [sdc] Sense not available.
[  588.931571] sd 7:0:0:0: [sdc] Write Protect is off
[  588.931576] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  588.931580] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  588.931768] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  588.931772] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  588.931780] sd 7:0:0:0: [sdc] Sense not available.
[  588.931819] sd 7:0:0:0: [sdc] Write Protect is off
[  588.931824] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  588.931828] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  590.928169] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  590.928178] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  590.928185] sd 7:0:0:0: [sdc] Sense not available.
[  590.929019] sd 7:0:0:0: [sdc] Write Protect is off
[  590.929026] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  590.929029] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  590.929767] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  590.929772] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  590.929778] sd 7:0:0:0: [sdc] Sense not available.
[  590.930524] sd 7:0:0:0: [sdc] Write Protect is off
[  590.930530] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  590.930533] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  592.924737] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  592.924743] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  592.924747] sd 7:0:0:0: [sdc] Sense not available.
[  592.924981] sd 7:0:0:0: [sdc] Write Protect is off
[  592.924983] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  592.924985] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  592.925229] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  592.925231] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  592.925234] sd 7:0:0:0: [sdc] Sense not available.
[  592.925252] sd 7:0:0:0: [sdc] Write Protect is off
[  592.925254] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  592.925255] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  594.921429] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  594.921439] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  594.921446] sd 7:0:0:0: [sdc] Sense not available.
[  594.921462] sd 7:0:0:0: [sdc] Write Protect is off
[  594.921466] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  594.921471] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  594.921528] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  594.921532] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  594.921540] sd 7:0:0:0: [sdc] Sense not available.
[  594.921555] sd 7:0:0:0: [sdc] Write Protect is off
[  594.921560] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  594.921564] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  596.918013] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  596.918022] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  596.918029] sd 7:0:0:0: [sdc] Sense not available.
[  596.918045] sd 7:0:0:0: [sdc] Write Protect is off
[  596.918049] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  596.918053] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  596.918214] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  596.918219] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  596.918226] sd 7:0:0:0: [sdc] Sense not available.
[  596.918248] sd 7:0:0:0: [sdc] Write Protect is off
[  596.918253] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  596.918257] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  598.914661] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  598.914671] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  598.914678] sd 7:0:0:0: [sdc] Sense not available.
[  598.914694] sd 7:0:0:0: [sdc] Write Protect is off
[  598.914701] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  598.914705] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  600.791162] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  600.791168] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  600.791176] sd 7:0:0:0: [sdc] Sense not available.
[  600.791192] sd 7:0:0:0: [sdc] Write Protect is off
[  600.791197] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  600.791202] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  602.787645] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  602.787653] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  602.787661] sd 7:0:0:0: [sdc] Sense not available.
[  602.787729] sd 7:0:0:0: [sdc] Write Protect is off
[  602.787733] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  602.787737] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  602.787796] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  602.787800] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  602.787809] sd 7:0:0:0: [sdc] Sense not available.
[  602.787824] sd 7:0:0:0: [sdc] Write Protect is off
[  602.787830] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  602.787834] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  604.784315] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  604.784325] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  604.784332] sd 7:0:0:0: [sdc] Sense not available.
[  604.784418] sd 7:0:0:0: [sdc] Write Protect is off
[  604.784423] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  604.784427] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  604.784488] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  604.784493] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  604.784501] sd 7:0:0:0: [sdc] Sense not available.
[  604.784517] sd 7:0:0:0: [sdc] Write Protect is off
[  604.784522] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  604.784526] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  606.780845] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  606.780854] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  606.780861] sd 7:0:0:0: [sdc] Sense not available.
[  606.780914] sd 7:0:0:0: [sdc] Write Protect is off
[  606.780918] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  606.780922] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  606.780981] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  606.780985] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  606.780992] sd 7:0:0:0: [sdc] Sense not available.
[  606.781007] sd 7:0:0:0: [sdc] Write Protect is off
[  606.781012] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  606.781016] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  608.777488] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  608.777497] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  608.777504] sd 7:0:0:0: [sdc] Sense not available.
[  608.777574] sd 7:0:0:0: [sdc] Write Protect is off
[  608.777579] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  608.777583] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  608.777645] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  608.777649] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  608.777657] sd 7:0:0:0: [sdc] Sense not available.
[  608.777673] sd 7:0:0:0: [sdc] Write Protect is off
[  608.777678] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  608.777682] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  610.774106] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  610.774117] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  610.774124] sd 7:0:0:0: [sdc] Sense not available.
[  610.774140] sd 7:0:0:0: [sdc] Write Protect is off
[  610.774145] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  610.774150] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  608.897901] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  608.897908] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  608.897916] sd 7:0:0:0: [sdc] Sense not available.
[  608.897932] sd 7:0:0:0: [sdc] Write Protect is off
[  608.897937] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  608.897941] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  610.894390] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  610.894401] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  610.894408] sd 7:0:0:0: [sdc] Sense not available.
[  610.894425] sd 7:0:0:0: [sdc] Write Protect is off
[  610.894429] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  610.894435] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  610.894493] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  610.894497] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  610.894505] sd 7:0:0:0: [sdc] Sense not available.
[  610.894520] sd 7:0:0:0: [sdc] Write Protect is off
[  610.894525] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  610.894529] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  612.890997] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  612.891007] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  612.891014] sd 7:0:0:0: [sdc] Sense not available.
[  612.891030] sd 7:0:0:0: [sdc] Write Protect is off
[  612.891036] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  612.891040] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  614.767539] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  614.767544] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  614.767550] sd 7:0:0:0: [sdc] Sense not available.
[  614.767577] sd 7:0:0:0: [sdc] Write Protect is off
[  614.767583] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  614.767587] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  616.763968] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  616.763978] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  616.763986] sd 7:0:0:0: [sdc] Sense not available.
[  616.764002] sd 7:0:0:0: [sdc] Write Protect is off
[  616.764006] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  616.764011] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  616.764070] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  616.764074] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  616.764081] sd 7:0:0:0: [sdc] Sense not available.
[  616.764097] sd 7:0:0:0: [sdc] Write Protect is off
[  616.764102] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  616.764106] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  618.760589] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  618.760598] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  618.760606] sd 7:0:0:0: [sdc] Sense not available.
[  618.760665] sd 7:0:0:0: [sdc] Write Protect is off
[  618.760669] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  618.760673] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  618.760735] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  618.760739] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  618.760747] sd 7:0:0:0: [sdc] Sense not available.
[  618.760762] sd 7:0:0:0: [sdc] Write Protect is off
[  618.760767] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  618.760772] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  620.757175] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  620.757184] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  620.757191] sd 7:0:0:0: [sdc] Sense not available.
[  620.757788] sd 7:0:0:0: [sdc] Write Protect is off
[  620.757794] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  620.757798] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  620.759482] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  620.759487] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  620.759493] sd 7:0:0:0: [sdc] Sense not available.
[  620.759547] sd 7:0:0:0: [sdc] Write Protect is off
[  620.759551] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  620.759556] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  622.753814] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  622.753823] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  622.753830] sd 7:0:0:0: [sdc] Sense not available.
[  622.754437] sd 7:0:0:0: [sdc] Write Protect is off
[  622.754443] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  622.754447] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  622.754985] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  622.754989] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  622.754997] sd 7:0:0:0: [sdc] Sense not available.
[  622.755013] sd 7:0:0:0: [sdc] Write Protect is off
[  622.755018] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  622.755022] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  624.750430] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  624.750440] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  624.750447] sd 7:0:0:0: [sdc] Sense not available.
[  624.750463] sd 7:0:0:0: [sdc] Write Protect is off
[  624.750467] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  624.750472] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  624.750532] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  624.750537] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  624.750544] sd 7:0:0:0: [sdc] Sense not available.
[  624.750560] sd 7:0:0:0: [sdc] Write Protect is off
[  624.750564] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  624.750569] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  626.747052] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  626.747062] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  626.747069] sd 7:0:0:0: [sdc] Sense not available.
[  626.747085] sd 7:0:0:0: [sdc] Write Protect is off
[  626.747090] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  626.747095] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  626.747154] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  626.747158] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  626.747166] sd 7:0:0:0: [sdc] Sense not available.
[  626.747182] sd 7:0:0:0: [sdc] Write Protect is off
[  626.747187] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  626.747191] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  628.743676] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  628.743685] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  628.743693] sd 7:0:0:0: [sdc] Sense not available.
[  628.743756] sd 7:0:0:0: [sdc] Write Protect is off
[  628.743760] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  628.743764] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  628.743826] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  628.743831] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  628.743838] sd 7:0:0:0: [sdc] Sense not available.
[  628.743854] sd 7:0:0:0: [sdc] Write Protect is off
[  628.743859] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  628.743864] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  630.743579] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  630.743588] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  630.743596] sd 7:0:0:0: [sdc] Sense not available.
[  630.744190] sd 7:0:0:0: [sdc] Write Protect is off
[  630.744196] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  630.744200] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  630.745828] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  630.745834] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  630.745839] sd 7:0:0:0: [sdc] Sense not available.
[  630.745893] sd 7:0:0:0: [sdc] Write Protect is off
[  630.745899] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  630.745903] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  632.740200] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  632.740209] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  632.740217] sd 7:0:0:0: [sdc] Sense not available.
[  632.740233] sd 7:0:0:0: [sdc] Write Protect is off
[  632.740237] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  632.740241] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  632.740298] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  632.740302] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  632.740310] sd 7:0:0:0: [sdc] Sense not available.
[  632.740325] sd 7:0:0:0: [sdc] Write Protect is off
[  632.740330] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  632.740335] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  634.736848] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  634.736858] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  634.736865] sd 7:0:0:0: [sdc] Sense not available.
[  634.736882] sd 7:0:0:0: [sdc] Write Protect is off
[  634.736888] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  634.736893] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  634.736952] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  634.736956] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  634.736964] sd 7:0:0:0: [sdc] Sense not available.
[  634.736979] sd 7:0:0:0: [sdc] Write Protect is off
[  634.736984] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  634.736988] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  636.734232] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  636.734241] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  636.734248] sd 7:0:0:0: [sdc] Sense not available.
[  636.734361] sd 7:0:0:0: [sdc] Write Protect is off
[  636.734365] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  636.734369] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  636.735360] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  636.735365] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  636.735370] sd 7:0:0:0: [sdc] Sense not available.
[  636.735676] sd 7:0:0:0: [sdc] Write Protect is off
[  636.735680] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  636.735684] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  638.730095] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  638.730105] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  638.730112] sd 7:0:0:0: [sdc] Sense not available.
[  638.730129] sd 7:0:0:0: [sdc] Write Protect is off
[  638.730133] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  638.730138] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  638.730196] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  638.730200] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  638.730208] sd 7:0:0:0: [sdc] Sense not available.
[  638.730223] sd 7:0:0:0: [sdc] Write Protect is off
[  638.730227] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  638.730232] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  640.726710] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  640.726720] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  640.726728] sd 7:0:0:0: [sdc] Sense not available.
[  640.726745] sd 7:0:0:0: [sdc] Write Protect is off
[  640.726749] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  640.726754] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  640.726813] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  640.726817] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  640.726824] sd 7:0:0:0: [sdc] Sense not available.
[  640.726839] sd 7:0:0:0: [sdc] Write Protect is off
[  640.726844] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  640.726848] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  642.723328] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  642.723337] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  642.723344] sd 7:0:0:0: [sdc] Sense not available.
[  642.723403] sd 7:0:0:0: [sdc] Write Protect is off
[  642.723408] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  642.723411] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  642.723472] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  642.723477] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  642.723484] sd 7:0:0:0: [sdc] Sense not available.
[  642.723500] sd 7:0:0:0: [sdc] Write Protect is off
[  642.723504] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  642.723509] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  644.719947] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  644.719956] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  644.719963] sd 7:0:0:0: [sdc] Sense not available.
[  644.720022] sd 7:0:0:0: [sdc] Write Protect is off
[  644.720026] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  644.720030] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  644.720089] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  644.720094] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  644.720101] sd 7:0:0:0: [sdc] Sense not available.
[  644.720117] sd 7:0:0:0: [sdc] Write Protect is off
[  644.720122] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  644.720126] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  646.716565] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  646.716574] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  646.716581] sd 7:0:0:0: [sdc] Sense not available.
[  646.716598] sd 7:0:0:0: [sdc] Write Protect is off
[  646.716604] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  646.716608] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  646.716664] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  646.716668] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  646.716676] sd 7:0:0:0: [sdc] Sense not available.
[  646.716691] sd 7:0:0:0: [sdc] Write Protect is off
[  646.716695] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  646.716700] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  648.713196] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  648.713205] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  648.713212] sd 7:0:0:0: [sdc] Sense not available.
[  648.713271] sd 7:0:0:0: [sdc] Write Protect is off
[  648.713275] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  648.713279] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  648.713338] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  648.713342] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  648.713351] sd 7:0:0:0: [sdc] Sense not available.
[  648.713366] sd 7:0:0:0: [sdc] Write Protect is off
[  648.713370] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  648.713375] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  650.709798] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  650.709808] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  650.709816] sd 7:0:0:0: [sdc] Sense not available.
[  650.709832] sd 7:0:0:0: [sdc] Write Protect is off
[  650.709837] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  650.709841] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  650.709900] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  650.709904] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  650.709912] sd 7:0:0:0: [sdc] Sense not available.
[  650.709928] sd 7:0:0:0: [sdc] Write Protect is off
[  650.709932] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  650.709936] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  652.707196] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  652.707205] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  652.707212] sd 7:0:0:0: [sdc] Sense not available.
[  652.707273] sd 7:0:0:0: [sdc] Write Protect is off
[  652.707278] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  652.707282] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  652.707342] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  652.707346] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  652.707354] sd 7:0:0:0: [sdc] Sense not available.
[  652.707369] sd 7:0:0:0: [sdc] Write Protect is off
[  652.707374] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  652.707379] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  654.703035] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  654.703045] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  654.703052] sd 7:0:0:0: [sdc] Sense not available.
[  654.703069] sd 7:0:0:0: [sdc] Write Protect is off
[  654.703074] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  654.703078] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  652.826841] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  652.826847] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  652.826855] sd 7:0:0:0: [sdc] Sense not available.
[  652.826870] sd 7:0:0:0: [sdc] Write Protect is off
[  652.826876] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  652.826880] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  654.823288] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  654.823297] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  654.823305] sd 7:0:0:0: [sdc] Sense not available.
[  656.699726] sd 7:0:0:0: [sdc] Write Protect is off
[  656.699733] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  656.699737] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  654.823493] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  654.823497] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  654.823505] sd 7:0:0:0: [sdc] Sense not available.
[  654.823521] sd 7:0:0:0: [sdc] Write Protect is off
[  654.823526] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  654.823530] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  656.819920] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  656.819929] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  656.819937] sd 7:0:0:0: [sdc] Sense not available.
[  656.820005] sd 7:0:0:0: [sdc] Write Protect is off
[  656.820009] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  656.820013] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  656.820075] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  656.820079] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  656.820087] sd 7:0:0:0: [sdc] Sense not available.
[  656.820102] sd 7:0:0:0: [sdc] Write Protect is off
[  656.820107] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  656.820111] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  658.816539] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  658.816549] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  658.816556] sd 7:0:0:0: [sdc] Sense not available.
[  658.816630] sd 7:0:0:0: [sdc] Write Protect is off
[  658.816635] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  658.816639] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  658.816701] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  658.816705] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  658.816713] sd 7:0:0:0: [sdc] Sense not available.
[  658.816729] sd 7:0:0:0: [sdc] Write Protect is off
[  658.816733] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  658.816737] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  660.813074] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  660.813080] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  660.813084] sd 7:0:0:0: [sdc] Sense not available.
[  662.689477] sd 7:0:0:0: [sdc] Write Protect is off
[  662.689481] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  662.689484] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  660.813205] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  660.813207] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  660.813211] sd 7:0:0:0: [sdc] Sense not available.
[  660.813218] sd 7:0:0:0: [sdc] Write Protect is off
[  660.813221] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  660.813224] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  662.809734] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  662.809744] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  662.809751] sd 7:0:0:0: [sdc] Sense not available.
[  662.809816] sd 7:0:0:0: [sdc] Write Protect is off
[  662.809820] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  662.809824] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  662.809883] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  662.809887] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  662.809895] sd 7:0:0:0: [sdc] Sense not available.
[  662.809910] sd 7:0:0:0: [sdc] Write Protect is off
[  662.809915] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  662.809919] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  664.806378] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  664.806388] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  664.806397] sd 7:0:0:0: [sdc] Sense not available.
[  664.806441] sd 7:0:0:0: [sdc] Write Protect is off
[  664.806447] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  664.806452] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  664.806590] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  664.806593] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  664.806601] sd 7:0:0:0: [sdc] Sense not available.
[  664.806633] sd 7:0:0:0: [sdc] Write Protect is off
[  664.806638] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  664.806642] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  666.803009] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  666.803019] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  666.803026] sd 7:0:0:0: [sdc] Sense not available.
[  666.803043] sd 7:0:0:0: [sdc] Write Protect is off
[  666.803048] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  666.803052] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  666.803110] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  666.803114] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  666.803122] sd 7:0:0:0: [sdc] Sense not available.
[  666.803137] sd 7:0:0:0: [sdc] Write Protect is off
[  666.803142] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  666.803146] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  668.799625] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  668.799635] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  668.799643] sd 7:0:0:0: [sdc] Sense not available.
[  668.799659] sd 7:0:0:0: [sdc] Write Protect is off
[  668.799664] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  668.799669] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  670.676129] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  670.676135] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  670.676143] sd 7:0:0:0: [sdc] Sense not available.
[  670.676159] sd 7:0:0:0: [sdc] Write Protect is off
[  670.676165] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  670.676169] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  672.672572] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  672.672581] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  672.672588] sd 7:0:0:0: [sdc] Sense not available.
[  672.672604] sd 7:0:0:0: [sdc] Write Protect is off
[  672.672610] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  672.672615] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  672.672671] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  672.672676] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  672.672683] sd 7:0:0:0: [sdc] Sense not available.
[  672.672699] sd 7:0:0:0: [sdc] Write Protect is off
[  672.672703] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  672.672708] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  674.669931] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  674.669940] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  674.669948] sd 7:0:0:0: [sdc] Sense not available.
[  674.669964] sd 7:0:0:0: [sdc] Write Protect is off
[  674.669969] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  674.669974] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  674.670032] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  674.670036] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  674.670044] sd 7:0:0:0: [sdc] Sense not available.
[  674.670059] sd 7:0:0:0: [sdc] Write Protect is off
[  674.670063] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  674.670068] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  676.665823] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  676.665832] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  676.665839] sd 7:0:0:0: [sdc] Sense not available.
[  676.666442] sd 7:0:0:0: [sdc] Write Protect is off
[  676.666448] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  676.666464] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  674.790776] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  674.790782] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  674.790788] sd 7:0:0:0: [sdc] Sense not available.
[  674.790804] sd 7:0:0:0: [sdc] Write Protect is off
[  674.790808] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  674.790812] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  676.786074] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  676.786083] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  676.786090] sd 7:0:0:0: [sdc] Sense not available.
[  678.662509] sd 7:0:0:0: [sdc] Write Protect is off
[  678.662516] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  678.662520] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  678.662610] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  678.662614] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  678.662622] sd 7:0:0:0: [sdc] Sense not available.
[  678.662638] sd 7:0:0:0: [sdc] Write Protect is off
[  678.662643] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  678.662647] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  680.663878] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  680.663887] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  680.663895] sd 7:0:0:0: [sdc] Sense not available.
[  680.663979] sd 7:0:0:0: [sdc] Write Protect is off
[  680.663985] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  680.663990] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  680.664123] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  680.664127] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  680.664135] sd 7:0:0:0: [sdc] Sense not available.
[  680.664164] sd 7:0:0:0: [sdc] Write Protect is off
[  680.664169] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  680.664173] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  682.665619] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  682.665628] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  682.665635] sd 7:0:0:0: [sdc] Sense not available.
[  682.665705] sd 7:0:0:0: [sdc] Write Protect is off
[  682.665709] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  682.665713] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  682.665774] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  682.665778] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  682.665785] sd 7:0:0:0: [sdc] Sense not available.
[  682.665801] sd 7:0:0:0: [sdc] Write Protect is off
[  682.665805] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  682.665810] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  684.662279] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  684.662289] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  684.662296] sd 7:0:0:0: [sdc] Sense not available.
[  684.662311] sd 7:0:0:0: [sdc] Write Protect is off
[  684.662317] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  684.662321] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  682.786095] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  682.786101] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  682.786110] sd 7:0:0:0: [sdc] Sense not available.
[  682.786126] sd 7:0:0:0: [sdc] Write Protect is off
[  682.786131] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  682.786136] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  684.782511] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  684.782520] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  684.782528] sd 7:0:0:0: [sdc] Sense not available.
[  684.782544] sd 7:0:0:0: [sdc] Write Protect is off
[  684.782549] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  684.782553] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  684.782745] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  684.782749] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  684.782757] sd 7:0:0:0: [sdc] Sense not available.
[  684.782958] sd 7:0:0:0: [sdc] Write Protect is off
[  684.782964] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  684.782968] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  686.779137] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  686.779146] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  686.779154] sd 7:0:0:0: [sdc] Sense not available.
[  686.779215] sd 7:0:0:0: [sdc] Write Protect is off
[  686.779219] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  686.779223] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  686.779283] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  686.779288] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  686.779295] sd 7:0:0:0: [sdc] Sense not available.
[  686.779311] sd 7:0:0:0: [sdc] Write Protect is off
[  686.779315] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  686.779320] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  688.775742] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  688.775751] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  688.775759] sd 7:0:0:0: [sdc] Sense not available.
[  688.776593] sd 7:0:0:0: [sdc] Write Protect is off
[  688.776600] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  688.776604] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  688.777069] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  688.777073] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  688.777079] sd 7:0:0:0: [sdc] Sense not available.
[  688.777100] sd 7:0:0:0: [sdc] Write Protect is off
[  688.777106] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  688.777110] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  690.772390] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  690.772400] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  690.772407] sd 7:0:0:0: [sdc] Sense not available.
[  690.772425] sd 7:0:0:0: [sdc] Write Protect is off
[  690.772430] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  690.772434] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  692.648902] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  692.648908] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  692.648916] sd 7:0:0:0: [sdc] Sense not available.
[  692.648932] sd 7:0:0:0: [sdc] Write Protect is off
[  692.648937] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  692.648942] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  694.645364] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  694.645373] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  694.645380] sd 7:0:0:0: [sdc] Sense not available.
[  694.645396] sd 7:0:0:0: [sdc] Write Protect is off
[  694.645402] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  694.645407] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  692.769219] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  692.769224] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  692.769233] sd 7:0:0:0: [sdc] Sense not available.
[  692.769250] sd 7:0:0:0: [sdc] Write Protect is off
[  692.769255] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  692.769260] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  694.765645] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  694.765655] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  694.765662] sd 7:0:0:0: [sdc] Sense not available.
[  694.765679] sd 7:0:0:0: [sdc] Write Protect is off
[  694.765684] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  694.765689] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  696.642128] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  696.642135] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  696.642143] sd 7:0:0:0: [sdc] Sense not available.
[  696.642159] sd 7:0:0:0: [sdc] Write Protect is off
[  696.642164] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  696.642169] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  698.639716] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  698.639725] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  698.639734] sd 7:0:0:0: [sdc] Sense not available.
[  698.639787] sd 7:0:0:0: [sdc] Write Protect is off
[  698.639792] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  698.639797] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  698.639964] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  698.639968] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  698.639976] sd 7:0:0:0: [sdc] Sense not available.
[  698.640005] sd 7:0:0:0: [sdc] Write Protect is off
[  698.640010] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  698.640014] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  700.639521] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  700.639530] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  700.639537] sd 7:0:0:0: [sdc] Sense not available.
[  700.639595] sd 7:0:0:0: [sdc] Write Protect is off
[  700.639599] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  700.639603] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  700.639667] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  700.639672] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  700.639679] sd 7:0:0:0: [sdc] Sense not available.
[  700.639695] sd 7:0:0:0: [sdc] Write Protect is off
[  700.639699] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  700.639704] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  702.635934] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  702.635943] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  702.635950] sd 7:0:0:0: [sdc] Sense not available.
[  702.635966] sd 7:0:0:0: [sdc] Write Protect is off
[  702.635971] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  702.635975] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  702.636151] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  702.636155] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  702.636162] sd 7:0:0:0: [sdc] Sense not available.
[  702.636195] sd 7:0:0:0: [sdc] Write Protect is off
[  702.636200] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  702.636205] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  704.631918] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  704.631926] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  704.631934] sd 7:0:0:0: [sdc] Sense not available.
[  704.631950] sd 7:0:0:0: [sdc] Write Protect is off
[  704.631956] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  704.631960] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  704.632018] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  704.632023] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  704.632031] sd 7:0:0:0: [sdc] Sense not available.
[  704.632046] sd 7:0:0:0: [sdc] Write Protect is off
[  704.632051] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  704.632055] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  706.645097] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  706.645106] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  706.645113] sd 7:0:0:0: [sdc] Sense not available.
[  706.645173] sd 7:0:0:0: [sdc] Write Protect is off
[  706.645177] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  706.645181] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  706.645241] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  706.645245] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  706.645252] sd 7:0:0:0: [sdc] Sense not available.
[  706.645268] sd 7:0:0:0: [sdc] Write Protect is off
[  706.645273] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  706.645277] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  708.641648] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  708.641658] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  708.641665] sd 7:0:0:0: [sdc] Sense not available.
[  708.641727] sd 7:0:0:0: [sdc] Write Protect is off
[  708.641731] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  708.641735] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  708.641796] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  708.641800] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  708.641809] sd 7:0:0:0: [sdc] Sense not available.
[  708.641824] sd 7:0:0:0: [sdc] Write Protect is off
[  708.641829] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  708.641833] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  710.639052] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  710.639060] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  710.639068] sd 7:0:0:0: [sdc] Sense not available.
[  710.639128] sd 7:0:0:0: [sdc] Write Protect is off
[  710.639133] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  710.639137] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  710.639198] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  710.639202] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  710.639210] sd 7:0:0:0: [sdc] Sense not available.
[  710.639224] sd 7:0:0:0: [sdc] Write Protect is off
[  710.639229] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  710.639234] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  712.635676] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  712.635686] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  712.635693] sd 7:0:0:0: [sdc] Sense not available.
[  712.635752] sd 7:0:0:0: [sdc] Write Protect is off
[  712.635757] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  712.635761] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  712.635820] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  712.635824] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  712.635832] sd 7:0:0:0: [sdc] Sense not available.
[  712.635847] sd 7:0:0:0: [sdc] Write Protect is off
[  712.635852] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  712.635856] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  714.631485] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  714.631494] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  714.631501] sd 7:0:0:0: [sdc] Sense not available.
[  714.631569] sd 7:0:0:0: [sdc] Write Protect is off
[  714.631573] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  714.631577] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  714.631637] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  714.631641] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  714.631649] sd 7:0:0:0: [sdc] Sense not available.
[  714.631664] sd 7:0:0:0: [sdc] Write Protect is off
[  714.631668] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  714.631673] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  716.628901] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  716.628910] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  716.628917] sd 7:0:0:0: [sdc] Sense not available.
[  716.628934] sd 7:0:0:0: [sdc] Write Protect is off
[  716.628939] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  716.628943] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  716.629032] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  716.629035] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  716.629041] sd 7:0:0:0: [sdc] Sense not available.
[  716.629055] sd 7:0:0:0: [sdc] Write Protect is off
[  716.629059] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  716.629064] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  716.751825] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  716.751835] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  716.751842] sd 7:0:0:0: [sdc] Sense not available.
[  716.751859] sd 7:0:0:0: [sdc] Write Protect is off
[  716.751863] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  716.751867] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  718.628322] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  718.628328] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  718.628336] sd 7:0:0:0: [sdc] Sense not available.
[  718.628352] sd 7:0:0:0: [sdc] Write Protect is off
[  718.628358] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  718.628362] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  720.625488] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  720.625499] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  720.625506] sd 7:0:0:0: [sdc] Sense not available.
[  720.625523] sd 7:0:0:0: [sdc] Write Protect is off
[  720.625528] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  720.625532] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  718.749305] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  718.749311] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  718.749319] sd 7:0:0:0: [sdc] Sense not available.
[  718.749335] sd 7:0:0:0: [sdc] Write Protect is off
[  718.749341] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  718.749345] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  720.746876] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  720.746885] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  720.746893] sd 7:0:0:0: [sdc] Sense not available.
[  720.746932] sd 7:0:0:0: [sdc] Write Protect is off
[  720.746937] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  720.746941] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  720.747001] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  720.747005] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  720.747013] sd 7:0:0:0: [sdc] Sense not available.
[  720.747028] sd 7:0:0:0: [sdc] Write Protect is off
[  720.747032] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  720.747037] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  722.744845] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  722.744855] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  722.744862] sd 7:0:0:0: [sdc] Sense not available.
[  722.744879] sd 7:0:0:0: [sdc] Write Protect is off
[  722.744884] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  722.744888] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  724.621351] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  724.621357] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  724.621365] sd 7:0:0:0: [sdc] Sense not available.
[  724.621381] sd 7:0:0:0: [sdc] Write Protect is off
[  724.621386] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  724.621391] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  726.617814] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  726.617823] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  726.617831] sd 7:0:0:0: [sdc] Sense not available.
[  726.617897] sd 7:0:0:0: [sdc] Write Protect is off
[  726.617901] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  726.617905] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  726.617965] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  726.617970] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  726.617977] sd 7:0:0:0: [sdc] Sense not available.
[  726.617992] sd 7:0:0:0: [sdc] Write Protect is off
[  726.617997] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  726.618001] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  728.614436] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  728.614445] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  728.614452] sd 7:0:0:0: [sdc] Sense not available.
[  728.614502] sd 7:0:0:0: [sdc] Write Protect is off
[  728.614507] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  728.614511] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  728.614570] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  728.614574] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  728.614581] sd 7:0:0:0: [sdc] Sense not available.
[  728.614597] sd 7:0:0:0: [sdc] Write Protect is off
[  728.614601] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  728.614606] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  730.611079] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  730.611089] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  730.611096] sd 7:0:0:0: [sdc] Sense not available.
[  730.611171] sd 7:0:0:0: [sdc] Write Protect is off
[  730.611175] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  730.611179] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  730.611242] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  730.611246] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  730.611254] sd 7:0:0:0: [sdc] Sense not available.
[  730.611269] sd 7:0:0:0: [sdc] Write Protect is off
[  730.611274] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  730.611278] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  732.608463] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  732.608472] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  732.608479] sd 7:0:0:0: [sdc] Sense not available.
[  732.608557] sd 7:0:0:0: [sdc] Write Protect is off
[  732.608562] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  732.608566] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  732.608797] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  732.608800] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  732.608806] sd 7:0:0:0: [sdc] Sense not available.
[  732.608835] sd 7:0:0:0: [sdc] Write Protect is off
[  732.608839] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  732.608843] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  732.734518] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  732.734527] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  732.734536] sd 7:0:0:0: [sdc] Sense not available.
[  732.734552] sd 7:0:0:0: [sdc] Write Protect is off
[  732.734558] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  732.734563] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  732.734621] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  732.734626] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  732.734634] sd 7:0:0:0: [sdc] Sense not available.
[  732.734649] sd 7:0:0:0: [sdc] Write Protect is off
[  732.734654] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  732.734658] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  734.731233] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  734.731244] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  734.731251] sd 7:0:0:0: [sdc] Sense not available.
[  734.731267] sd 7:0:0:0: [sdc] Write Protect is off
[  734.731273] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  734.731278] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  734.731336] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  734.731340] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  734.731348] sd 7:0:0:0: [sdc] Sense not available.
[  734.731363] sd 7:0:0:0: [sdc] Write Protect is off
[  734.731368] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  734.731372] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  736.727833] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  736.727842] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  736.727849] sd 7:0:0:0: [sdc] Sense not available.
[  736.727899] sd 7:0:0:0: [sdc] Write Protect is off
[  736.727904] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  736.727908] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  736.728428] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  736.728431] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  736.728437] sd 7:0:0:0: [sdc] Sense not available.
[  736.728472] sd 7:0:0:0: [sdc] Write Protect is off
[  736.728476] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  736.728479] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  738.724432] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  738.724440] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  738.724447] sd 7:0:0:0: [sdc] Sense not available.
[  738.724501] sd 7:0:0:0: [sdc] Write Protect is off
[  738.724505] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  738.724509] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  738.724569] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  738.724573] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  738.724581] sd 7:0:0:0: [sdc] Sense not available.
[  738.724597] sd 7:0:0:0: [sdc] Write Protect is off
[  738.724602] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  738.724606] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  740.721074] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  740.721083] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  740.721090] sd 7:0:0:0: [sdc] Sense not available.
[  740.721158] sd 7:0:0:0: [sdc] Write Protect is off
[  740.721162] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  740.721166] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  740.721227] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  740.721231] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  740.721238] sd 7:0:0:0: [sdc] Sense not available.
[  740.721254] sd 7:0:0:0: [sdc] Write Protect is off
[  740.721258] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  740.721263] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  742.717686] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  742.717696] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  742.717704] sd 7:0:0:0: [sdc] Sense not available.
[  742.717752] sd 7:0:0:0: [sdc] Write Protect is off
[  742.717758] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  742.717763] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  742.717918] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  742.717923] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  742.717930] sd 7:0:0:0: [sdc] Sense not available.
[  742.717963] sd 7:0:0:0: [sdc] Write Protect is off
[  742.717968] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  742.717972] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  744.714288] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  744.714297] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  744.714304] sd 7:0:0:0: [sdc] Sense not available.
[  744.714358] sd 7:0:0:0: [sdc] Write Protect is off
[  744.714362] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  744.714366] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  744.714624] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  744.714628] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  744.714633] sd 7:0:0:0: [sdc] Sense not available.
[  744.714668] sd 7:0:0:0: [sdc] Write Protect is off
[  744.714672] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  744.714676] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  746.710916] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  746.710925] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  746.710934] sd 7:0:0:0: [sdc] Sense not available.
[  746.710987] sd 7:0:0:0: [sdc] Write Protect is off
[  746.710993] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  746.710997] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  746.711425] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  746.711430] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  746.711438] sd 7:0:0:0: [sdc] Sense not available.
[  746.711459] sd 7:0:0:0: [sdc] Write Protect is off
[  746.711464] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  746.711469] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  748.708347] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  748.708356] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  748.708363] sd 7:0:0:0: [sdc] Sense not available.
[  748.708431] sd 7:0:0:0: [sdc] Write Protect is off
[  748.708435] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  748.708439] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  748.708500] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  748.708504] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  748.708512] sd 7:0:0:0: [sdc] Sense not available.
[  748.708527] sd 7:0:0:0: [sdc] Write Protect is off
[  748.708532] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  748.708536] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  752.580498] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  752.580507] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  752.580516] sd 7:0:0:0: [sdc] Sense not available.
[  752.580539] sd 7:0:0:0: [sdc] Write Protect is off
[  752.580544] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  752.580549] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  752.580718] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  752.580722] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  752.580730] sd 7:0:0:0: [sdc] Sense not available.
[  752.580763] sd 7:0:0:0: [sdc] Write Protect is off
[  752.580768] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  752.580773] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  754.577126] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  754.577135] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  754.577144] sd 7:0:0:0: [sdc] Sense not available.
[  754.577166] sd 7:0:0:0: [sdc] Write Protect is off
[  754.577172] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  754.577177] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  754.577340] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  754.577344] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  754.577352] sd 7:0:0:0: [sdc] Sense not available.
[  754.577384] sd 7:0:0:0: [sdc] Write Protect is off
[  754.577389] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  754.577394] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  756.574552] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  756.574561] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  756.574568] sd 7:0:0:0: [sdc] Sense not available.
[  756.574629] sd 7:0:0:0: [sdc] Write Protect is off
[  756.574634] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  756.574638] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  756.574697] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  756.574702] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  756.574710] sd 7:0:0:0: [sdc] Sense not available.
[  756.574725] sd 7:0:0:0: [sdc] Write Protect is off
[  756.574730] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  756.574734] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  758.570349] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  758.570359] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  758.570367] sd 7:0:0:0: [sdc] Sense not available.
[  758.570421] sd 7:0:0:0: [sdc] Write Protect is off
[  758.570426] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  758.570431] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  758.570808] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  758.570813] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  758.570821] sd 7:0:0:0: [sdc] Sense not available.
[  758.570854] sd 7:0:0:0: [sdc] Write Protect is off
[  758.570858] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  758.570863] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  760.566957] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  760.566966] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  760.566973] sd 7:0:0:0: [sdc] Sense not available.
[  760.567030] sd 7:0:0:0: [sdc] Write Protect is off
[  760.567035] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  760.567039] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  760.567255] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  760.567259] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  760.567264] sd 7:0:0:0: [sdc] Sense not available.
[  760.567280] sd 7:0:0:0: [sdc] Write Protect is off
[  760.567285] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  760.567290] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  762.563583] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  762.563592] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  762.563599] sd 7:0:0:0: [sdc] Sense not available.
[  762.563615] sd 7:0:0:0: [sdc] Write Protect is off
[  762.563621] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  762.563625] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  760.687399] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  760.687405] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  760.687413] sd 7:0:0:0: [sdc] Sense not available.
[  760.687430] sd 7:0:0:0: [sdc] Write Protect is off
[  760.687435] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  760.687440] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  762.683862] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  762.683872] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  762.683879] sd 7:0:0:0: [sdc] Sense not available.
[  762.683894] sd 7:0:0:0: [sdc] Write Protect is off
[  762.683899] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  762.683904] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  762.683960] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  762.683964] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  762.683972] sd 7:0:0:0: [sdc] Sense not available.
[  762.683987] sd 7:0:0:0: [sdc] Write Protect is off
[  762.683991] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  762.683996] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  764.680541] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  764.680549] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  764.680557] sd 7:0:0:0: [sdc] Sense not available.
[  764.680606] sd 7:0:0:0: [sdc] Write Protect is off
[  764.680611] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  764.680615] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  764.681107] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  764.681110] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  764.681116] sd 7:0:0:0: [sdc] Sense not available.
[  764.681149] sd 7:0:0:0: [sdc] Write Protect is off
[  764.681152] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  764.681156] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  766.677896] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  766.677904] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  766.677912] sd 7:0:0:0: [sdc] Sense not available.
[  766.678213] sd 7:0:0:0: [sdc] Write Protect is off
[  766.678218] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  766.678222] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  766.678617] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  766.678620] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  766.678626] sd 7:0:0:0: [sdc] Sense not available.
[  766.678679] sd 7:0:0:0: [sdc] Write Protect is off
[  766.678683] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  766.678687] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  768.673742] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  768.673751] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  768.673758] sd 7:0:0:0: [sdc] Sense not available.
[  768.674622] sd 7:0:0:0: [sdc] Write Protect is off
[  768.674629] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  768.674633] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  768.675453] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  768.675459] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  768.675465] sd 7:0:0:0: [sdc] Sense not available.
[  768.676251] sd 7:0:0:0: [sdc] Write Protect is off
[  768.676258] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  768.676261] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  772.550011] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  772.550021] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  772.550028] sd 7:0:0:0: [sdc] Sense not available.
[  772.550044] sd 7:0:0:0: [sdc] Write Protect is off
[  772.550050] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  772.550055] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  772.550112] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  772.550116] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  772.550124] sd 7:0:0:0: [sdc] Sense not available.
[  772.550139] sd 7:0:0:0: [sdc] Write Protect is off
[  772.550143] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  772.550148] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  774.547397] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  774.547406] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  774.547413] sd 7:0:0:0: [sdc] Sense not available.
[  774.547429] sd 7:0:0:0: [sdc] Write Protect is off
[  774.547434] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  774.547438] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  774.547655] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  774.547659] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  774.547667] sd 7:0:0:0: [sdc] Sense not available.
[  774.547888] sd 7:0:0:0: [sdc] Write Protect is off
[  774.547894] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  774.547898] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  776.543269] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  776.543278] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  776.543285] sd 7:0:0:0: [sdc] Sense not available.
[  776.543301] sd 7:0:0:0: [sdc] Write Protect is off
[  776.543307] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  776.543311] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  774.667083] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  774.667089] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  774.667097] sd 7:0:0:0: [sdc] Sense not available.
[  774.667112] sd 7:0:0:0: [sdc] Write Protect is off
[  774.667118] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  774.667122] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  776.663506] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  776.663516] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  776.663523] sd 7:0:0:0: [sdc] Sense not available.
[  776.663539] sd 7:0:0:0: [sdc] Write Protect is off
[  776.663545] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  776.663549] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  778.540048] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  778.540054] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  778.540062] sd 7:0:0:0: [sdc] Sense not available.
[  778.540078] sd 7:0:0:0: [sdc] Write Protect is off
[  778.540083] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  778.540088] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  780.536479] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  780.536488] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  780.536496] sd 7:0:0:0: [sdc] Sense not available.
[  780.536573] sd 7:0:0:0: [sdc] Write Protect is off
[  780.536577] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  780.536581] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  780.536644] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  780.536649] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  780.536656] sd 7:0:0:0: [sdc] Sense not available.
[  780.536671] sd 7:0:0:0: [sdc] Write Protect is off
[  780.536676] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  780.536680] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  782.533927] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  782.533936] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  782.533943] sd 7:0:0:0: [sdc] Sense not available.
[  782.534011] sd 7:0:0:0: [sdc] Write Protect is off
[  782.534016] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  782.534020] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  782.534080] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  782.534084] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  782.534092] sd 7:0:0:0: [sdc] Sense not available.
[  782.534108] sd 7:0:0:0: [sdc] Write Protect is off
[  782.534113] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  782.534118] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  784.529720] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  784.529729] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  784.529737] sd 7:0:0:0: [sdc] Sense not available.
[  784.529804] sd 7:0:0:0: [sdc] Write Protect is off
[  784.529808] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  784.529813] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  784.529875] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  784.529879] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  784.529888] sd 7:0:0:0: [sdc] Sense not available.
[  784.529903] sd 7:0:0:0: [sdc] Write Protect is off
[  784.529909] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  784.529913] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  786.533006] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  786.533016] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  786.533023] sd 7:0:0:0: [sdc] Sense not available.
[  786.533039] sd 7:0:0:0: [sdc] Write Protect is off
[  786.533046] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  786.533050] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  784.656828] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  784.656833] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  784.656841] sd 7:0:0:0: [sdc] Sense not available.
[  784.656857] sd 7:0:0:0: [sdc] Write Protect is off
[  784.656863] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  784.656867] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  786.653273] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  786.653283] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  786.653291] sd 7:0:0:0: [sdc] Sense not available.
[  786.653306] sd 7:0:0:0: [sdc] Write Protect is off
[  786.653311] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  786.653316] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  788.529771] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  788.529777] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  788.529785] sd 7:0:0:0: [sdc] Sense not available.
[  788.529801] sd 7:0:0:0: [sdc] Write Protect is off
[  788.529807] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  788.529811] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  790.526228] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  790.526237] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  790.526245] sd 7:0:0:0: [sdc] Sense not available.
[  790.526311] sd 7:0:0:0: [sdc] Write Protect is off
[  790.526316] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  790.526320] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  790.526383] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  790.526387] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  790.526394] sd 7:0:0:0: [sdc] Sense not available.
[  790.526410] sd 7:0:0:0: [sdc] Write Protect is off
[  790.526415] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  790.526419] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  792.522806] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  792.522814] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  792.522821] sd 7:0:0:0: [sdc] Sense not available.
[  792.522838] sd 7:0:0:0: [sdc] Write Protect is off
[  792.522842] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  792.522846] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  790.646613] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  790.646619] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  790.646627] sd 7:0:0:0: [sdc] Sense not available.
[  790.646643] sd 7:0:0:0: [sdc] Write Protect is off
[  790.646648] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  790.646653] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  792.643112] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  792.643121] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  792.643128] sd 7:0:0:0: [sdc] Sense not available.
[  792.643201] sd 7:0:0:0: [sdc] Write Protect is off
[  792.643206] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  792.643210] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  792.643271] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  792.643275] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  792.643283] sd 7:0:0:0: [sdc] Sense not available.
[  792.643298] sd 7:0:0:0: [sdc] Write Protect is off
[  792.643303] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  792.643307] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  794.639727] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  794.639736] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  794.639743] sd 7:0:0:0: [sdc] Sense not available.
[  794.639759] sd 7:0:0:0: [sdc] Write Protect is off
[  794.639765] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  794.639770] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  796.516203] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  796.516209] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  796.516217] sd 7:0:0:0: [sdc] Sense not available.
[  796.516233] sd 7:0:0:0: [sdc] Write Protect is off
[  796.516237] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  796.516242] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  798.512672] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  798.512681] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  798.512688] sd 7:0:0:0: [sdc] Sense not available.
[  798.512760] sd 7:0:0:0: [sdc] Write Protect is off
[  798.512764] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  798.512768] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  798.512828] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  798.512832] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  798.512839] sd 7:0:0:0: [sdc] Sense not available.
[  798.512855] sd 7:0:0:0: [sdc] Write Protect is off
[  798.512859] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  798.512864] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  800.509296] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  800.509306] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  800.509313] sd 7:0:0:0: [sdc] Sense not available.
[  800.509379] sd 7:0:0:0: [sdc] Write Protect is off
[  800.509384] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  800.509388] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  800.509450] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  800.509455] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  800.509462] sd 7:0:0:0: [sdc] Sense not available.
[  800.509478] sd 7:0:0:0: [sdc] Write Protect is off
[  800.509483] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  800.509487] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  802.505910] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  802.505920] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  802.505927] sd 7:0:0:0: [sdc] Sense not available.
[  802.505943] sd 7:0:0:0: [sdc] Write Protect is off
[  802.505948] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  802.505952] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  800.629731] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  800.629737] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  800.629744] sd 7:0:0:0: [sdc] Sense not available.
[  800.629760] sd 7:0:0:0: [sdc] Write Protect is off
[  800.629765] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  800.629770] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  802.626173] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  802.626181] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  802.626188] sd 7:0:0:0: [sdc] Sense not available.
[  802.626260] sd 7:0:0:0: [sdc] Write Protect is off
[  802.626265] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  802.626269] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  802.626328] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  802.626332] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  802.626339] sd 7:0:0:0: [sdc] Sense not available.
[  802.626355] sd 7:0:0:0: [sdc] Write Protect is off
[  802.626359] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  802.626364] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  804.622793] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  804.622802] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  804.622809] sd 7:0:0:0: [sdc] Sense not available.
[  804.622877] sd 7:0:0:0: [sdc] Write Protect is off
[  804.622881] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  804.622885] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  804.622946] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  804.622950] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  804.622958] sd 7:0:0:0: [sdc] Sense not available.
[  804.622974] sd 7:0:0:0: [sdc] Write Protect is off
[  804.622979] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  804.622984] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  806.619425] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  806.619434] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  806.619441] sd 7:0:0:0: [sdc] Sense not available.
[  806.619518] sd 7:0:0:0: [sdc] Write Protect is off
[  806.619523] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  806.619527] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  806.619588] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  806.619592] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  806.619600] sd 7:0:0:0: [sdc] Sense not available.
[  806.619616] sd 7:0:0:0: [sdc] Write Protect is off
[  806.619620] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  806.619624] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  808.616039] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  808.616049] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  808.616056] sd 7:0:0:0: [sdc] Sense not available.
[  808.616072] sd 7:0:0:0: [sdc] Write Protect is off
[  808.616077] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  808.616082] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  808.616139] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  808.616143] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  808.616151] sd 7:0:0:0: [sdc] Sense not available.
[  808.616166] sd 7:0:0:0: [sdc] Write Protect is off
[  808.616171] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  808.616175] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  810.612648] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  810.612658] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  810.612665] sd 7:0:0:0: [sdc] Sense not available.
[  810.612681] sd 7:0:0:0: [sdc] Write Protect is off
[  810.612688] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  810.612692] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  812.489150] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  812.489156] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  812.489164] sd 7:0:0:0: [sdc] Sense not available.
[  812.489180] sd 7:0:0:0: [sdc] Write Protect is off
[  812.489185] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  812.489190] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  814.485610] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  814.485620] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  814.485627] sd 7:0:0:0: [sdc] Sense not available.
[  814.485645] sd 7:0:0:0: [sdc] Write Protect is off
[  814.485649] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  814.485653] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  812.609438] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  812.609444] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  812.609452] sd 7:0:0:0: [sdc] Sense not available.
[  812.609468] sd 7:0:0:0: [sdc] Write Protect is off
[  812.609473] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  812.609478] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  814.605877] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  814.605886] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  814.605893] sd 7:0:0:0: [sdc] Sense not available.
[  814.606486] sd 7:0:0:0: [sdc] Write Protect is off
[  814.606492] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  814.606496] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  814.607095] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  814.607101] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  814.607107] sd 7:0:0:0: [sdc] Sense not available.
[  814.607673] sd 7:0:0:0: [sdc] Write Protect is off
[  814.607679] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  814.607682] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  816.602505] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  816.602514] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  816.602521] sd 7:0:0:0: [sdc] Sense not available.
[  816.603121] sd 7:0:0:0: [sdc] Write Protect is off
[  816.603127] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  816.603131] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  816.603652] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  816.603656] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  816.603663] sd 7:0:0:0: [sdc] Sense not available.
[  816.603680] sd 7:0:0:0: [sdc] Write Protect is off
[  816.603685] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  816.603689] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  818.599062] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  818.599071] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  818.599079] sd 7:0:0:0: [sdc] Sense not available.
[  818.599154] sd 7:0:0:0: [sdc] Write Protect is off
[  818.599159] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  818.599163] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  818.599393] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  818.599396] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  818.599402] sd 7:0:0:0: [sdc] Sense not available.
[  818.599473] sd 7:0:0:0: [sdc] Write Protect is off
[  818.599477] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  818.599481] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  822.472040] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  822.472049] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  822.472056] sd 7:0:0:0: [sdc] Sense not available.
[  822.472924] sd 7:0:0:0: [sdc] Write Protect is off
[  822.472931] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  822.472935] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  822.473680] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  822.473685] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  822.473691] sd 7:0:0:0: [sdc] Sense not available.
[  822.474442] sd 7:0:0:0: [sdc] Write Protect is off
[  822.474448] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  822.474451] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  824.468663] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  824.468672] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  824.468679] sd 7:0:0:0: [sdc] Sense not available.
[  822.593008] sd 7:0:0:0: [sdc] Write Protect is off
[  822.593015] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  822.593019] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  822.593094] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  822.593099] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  822.593107] sd 7:0:0:0: [sdc] Sense not available.
[  822.593123] sd 7:0:0:0: [sdc] Write Protect is off
[  822.593128] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  822.593132] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  824.588935] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  824.588944] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  824.588951] sd 7:0:0:0: [sdc] Sense not available.
[  824.589017] sd 7:0:0:0: [sdc] Write Protect is off
[  824.589021] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  824.589025] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  824.589085] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  824.589089] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  824.589097] sd 7:0:0:0: [sdc] Sense not available.
[  824.589112] sd 7:0:0:0: [sdc] Write Protect is off
[  824.589117] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  824.589121] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  826.588877] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  826.588886] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  826.588893] sd 7:0:0:0: [sdc] Sense not available.
[  826.588977] sd 7:0:0:0: [sdc] Write Protect is off
[  826.588981] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  826.588985] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  826.589046] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  826.589051] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  826.589059] sd 7:0:0:0: [sdc] Sense not available.
[  826.589074] sd 7:0:0:0: [sdc] Write Protect is off
[  826.589078] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  826.589083] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  828.588709] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  828.588718] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  828.588725] sd 7:0:0:0: [sdc] Sense not available.
[  828.588743] sd 7:0:0:0: [sdc] Write Protect is off
[  828.588748] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  828.588753] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  828.588813] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  828.588817] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  828.588825] sd 7:0:0:0: [sdc] Sense not available.
[  828.588841] sd 7:0:0:0: [sdc] Write Protect is off
[  828.588845] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  828.588850] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  830.585461] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  830.585470] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  830.585478] sd 7:0:0:0: [sdc] Sense not available.
[  830.585494] sd 7:0:0:0: [sdc] Write Protect is off
[  830.585498] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  830.585503] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  832.461951] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  832.461957] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  832.461965] sd 7:0:0:0: [sdc] Sense not available.
[  832.461980] sd 7:0:0:0: [sdc] Write Protect is off
[  832.461986] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  832.461990] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  834.458397] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  834.458405] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  834.458412] sd 7:0:0:0: [sdc] Sense not available.
[  834.458477] sd 7:0:0:0: [sdc] Write Protect is off
[  834.458482] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  834.458486] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  834.458545] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  834.458549] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  834.458557] sd 7:0:0:0: [sdc] Sense not available.
[  834.458573] sd 7:0:0:0: [sdc] Write Protect is off
[  834.458578] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  834.458583] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  836.455039] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  836.455048] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  836.455055] sd 7:0:0:0: [sdc] Sense not available.
[  836.455129] sd 7:0:0:0: [sdc] Write Protect is off
[  836.455133] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  836.455137] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  836.455201] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  836.455205] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  836.455213] sd 7:0:0:0: [sdc] Sense not available.
[  836.455228] sd 7:0:0:0: [sdc] Write Protect is off
[  836.455233] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  836.455237] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  838.451666] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  838.451674] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  838.451681] sd 7:0:0:0: [sdc] Sense not available.
[  838.451747] sd 7:0:0:0: [sdc] Write Protect is off
[  838.451752] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  838.451756] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  838.451816] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  838.451820] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  838.451827] sd 7:0:0:0: [sdc] Sense not available.
[  838.451843] sd 7:0:0:0: [sdc] Write Protect is off
[  838.451847] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  838.451851] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  840.448281] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  840.448290] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  840.448298] sd 7:0:0:0: [sdc] Sense not available.
[  840.448365] sd 7:0:0:0: [sdc] Write Protect is off
[  840.448370] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  840.448374] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  840.448437] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  840.448442] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  840.448449] sd 7:0:0:0: [sdc] Sense not available.
[  840.448465] sd 7:0:0:0: [sdc] Write Protect is off
[  840.448470] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  840.448475] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  842.444899] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  842.444910] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  842.444917] sd 7:0:0:0: [sdc] Sense not available.
[  842.444933] sd 7:0:0:0: [sdc] Write Protect is off
[  842.444937] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  842.444942] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  842.445001] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  842.445006] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  842.445014] sd 7:0:0:0: [sdc] Sense not available.
[  842.445029] sd 7:0:0:0: [sdc] Write Protect is off
[  842.445033] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  842.445038] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  844.441511] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  844.441521] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  844.441528] sd 7:0:0:0: [sdc] Sense not available.
[  844.441600] sd 7:0:0:0: [sdc] Write Protect is off
[  844.441604] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  844.441608] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  844.441671] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  844.441675] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  844.441683] sd 7:0:0:0: [sdc] Sense not available.
[  844.441698] sd 7:0:0:0: [sdc] Write Protect is off
[  844.441703] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  844.441707] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  846.438125] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  846.438134] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  846.438142] sd 7:0:0:0: [sdc] Sense not available.
[  846.438215] sd 7:0:0:0: [sdc] Write Protect is off
[  846.438220] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  846.438224] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  846.438287] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  846.438292] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  846.438299] sd 7:0:0:0: [sdc] Sense not available.
[  846.438315] sd 7:0:0:0: [sdc] Write Protect is off
[  846.438320] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  846.438325] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  848.435538] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  848.435548] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  848.435555] sd 7:0:0:0: [sdc] Sense not available.
[  848.435626] sd 7:0:0:0: [sdc] Write Protect is off
[  848.435630] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  848.435634] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  848.435693] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  848.435698] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  848.435705] sd 7:0:0:0: [sdc] Sense not available.
[  848.435720] sd 7:0:0:0: [sdc] Write Protect is off
[  848.435725] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  848.435729] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  850.432153] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  850.432163] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  850.432170] sd 7:0:0:0: [sdc] Sense not available.
[  850.432248] sd 7:0:0:0: [sdc] Write Protect is off
[  850.432253] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  850.432257] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  850.432316] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  850.432321] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  850.432326] sd 7:0:0:0: [sdc] Sense not available.
[  850.432342] sd 7:0:0:0: [sdc] Write Protect is off
[  850.432346] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  850.432350] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  852.437421] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  852.437429] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  852.437436] sd 7:0:0:0: [sdc] Sense not available.
[  852.437452] sd 7:0:0:0: [sdc] Write Protect is off
[  852.437457] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  852.437461] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  852.437517] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  852.437521] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  852.437529] sd 7:0:0:0: [sdc] Sense not available.
[  852.437544] sd 7:0:0:0: [sdc] Write Protect is off
[  852.437549] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  852.437553] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  854.435388] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  854.435397] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  854.435404] sd 7:0:0:0: [sdc] Sense not available.
[  854.435478] sd 7:0:0:0: [sdc] Write Protect is off
[  854.435482] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  854.435486] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  854.435550] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  854.435554] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  854.435562] sd 7:0:0:0: [sdc] Sense not available.
[  854.435578] sd 7:0:0:0: [sdc] Write Protect is off
[  854.435582] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  854.435587] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  856.434472] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  856.434481] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  856.434488] sd 7:0:0:0: [sdc] Sense not available.
[  856.434549] sd 7:0:0:0: [sdc] Write Protect is off
[  856.434553] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  856.434557] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  856.434618] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  856.434622] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  856.434630] sd 7:0:0:0: [sdc] Sense not available.
[  856.434646] sd 7:0:0:0: [sdc] Write Protect is off
[  856.434650] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  856.434655] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  858.431126] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  858.431136] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  858.431143] sd 7:0:0:0: [sdc] Sense not available.
[  858.431160] sd 7:0:0:0: [sdc] Write Protect is off
[  858.431165] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  858.431171] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  856.554922] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  856.554928] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  856.554937] sd 7:0:0:0: [sdc] Sense not available.
[  856.554952] sd 7:0:0:0: [sdc] Write Protect is off
[  856.554958] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  856.554963] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  858.551407] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  858.551417] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  858.551424] sd 7:0:0:0: [sdc] Sense not available.
[  858.551440] sd 7:0:0:0: [sdc] Write Protect is off
[  858.551444] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  858.551450] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  858.551507] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  858.551511] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  858.551519] sd 7:0:0:0: [sdc] Sense not available.
[  858.551534] sd 7:0:0:0: [sdc] Write Protect is off
[  858.551539] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  858.551544] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  860.547999] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  860.548008] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  860.548015] sd 7:0:0:0: [sdc] Sense not available.
[  860.548083] sd 7:0:0:0: [sdc] Write Protect is off
[  860.548087] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  860.548091] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  860.548151] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  860.548156] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  860.548163] sd 7:0:0:0: [sdc] Sense not available.
[  860.548178] sd 7:0:0:0: [sdc] Write Protect is off
[  860.548182] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  860.548187] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  862.544626] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  862.544636] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  862.544643] sd 7:0:0:0: [sdc] Sense not available.
[  862.544719] sd 7:0:0:0: [sdc] Write Protect is off
[  862.544724] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  862.544728] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  862.544789] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  862.544794] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  862.544799] sd 7:0:0:0: [sdc] Sense not available.
[  862.544815] sd 7:0:0:0: [sdc] Write Protect is off
[  862.544819] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  862.544823] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  864.541219] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  864.541229] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  864.541236] sd 7:0:0:0: [sdc] Sense not available.
[  864.541252] sd 7:0:0:0: [sdc] Write Protect is off
[  864.541256] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  864.541260] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  864.541319] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  864.541323] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  864.541331] sd 7:0:0:0: [sdc] Sense not available.
[  864.541347] sd 7:0:0:0: [sdc] Write Protect is off
[  864.541351] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  864.541356] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  866.537835] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  866.537844] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  866.537851] sd 7:0:0:0: [sdc] Sense not available.
[  866.537925] sd 7:0:0:0: [sdc] Write Protect is off
[  866.537929] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  866.537933] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  866.537994] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  866.537998] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  866.538006] sd 7:0:0:0: [sdc] Sense not available.
[  866.538021] sd 7:0:0:0: [sdc] Write Protect is off
[  866.538026] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  866.538030] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  868.534491] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  868.534498] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  868.534506] sd 7:0:0:0: [sdc] Sense not available.
[  868.534561] sd 7:0:0:0: [sdc] Write Protect is off
[  868.534566] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  868.534570] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  868.534629] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  868.534634] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  868.534640] sd 7:0:0:0: [sdc] Sense not available.
[  868.534655] sd 7:0:0:0: [sdc] Write Protect is off
[  868.534659] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  868.534664] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  870.531065] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  870.531073] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  870.531081] sd 7:0:0:0: [sdc] Sense not available.
[  870.531096] sd 7:0:0:0: [sdc] Write Protect is off
[  870.531102] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  870.531106] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  870.531163] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  870.531167] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  870.531174] sd 7:0:0:0: [sdc] Sense not available.
[  870.531190] sd 7:0:0:0: [sdc] Write Protect is off
[  870.531194] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  870.531199] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  872.527683] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  872.527693] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  872.527700] sd 7:0:0:0: [sdc] Sense not available.
[  872.527767] sd 7:0:0:0: [sdc] Write Protect is off
[  872.527772] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  872.527776] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  872.527836] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  872.527841] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  872.527849] sd 7:0:0:0: [sdc] Sense not available.
[  872.527863] sd 7:0:0:0: [sdc] Write Protect is off
[  872.527868] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  872.527873] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  874.524298] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  874.524307] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  874.524314] sd 7:0:0:0: [sdc] Sense not available.
[  874.524381] sd 7:0:0:0: [sdc] Write Protect is off
[  874.524385] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  874.524389] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  874.524449] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  874.524454] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  874.524461] sd 7:0:0:0: [sdc] Sense not available.
[  874.524476] sd 7:0:0:0: [sdc] Write Protect is off
[  874.524481] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  874.524485] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  876.520936] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  876.520945] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  876.520952] sd 7:0:0:0: [sdc] Sense not available.
[  876.520968] sd 7:0:0:0: [sdc] Write Protect is off
[  876.520974] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  876.520978] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  876.521035] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  876.521039] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  876.521047] sd 7:0:0:0: [sdc] Sense not available.
[  876.521063] sd 7:0:0:0: [sdc] Write Protect is off
[  876.521067] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  876.521072] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  878.517605] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  878.517615] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  878.517622] sd 7:0:0:0: [sdc] Sense not available.
[  878.517639] sd 7:0:0:0: [sdc] Write Protect is off
[  878.517644] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  878.517649] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  880.394091] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  880.394097] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  880.394105] sd 7:0:0:0: [sdc] Sense not available.
[  880.394122] sd 7:0:0:0: [sdc] Write Protect is off
[  880.394127] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  880.394131] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  882.390574] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  882.390581] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  882.390588] sd 7:0:0:0: [sdc] Sense not available.
[  882.390604] sd 7:0:0:0: [sdc] Write Protect is off
[  882.390610] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  882.390614] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  880.514398] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  880.514404] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  880.514412] sd 7:0:0:0: [sdc] Sense not available.
[  880.514428] sd 7:0:0:0: [sdc] Write Protect is off
[  880.514433] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  880.514438] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  882.510887] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  882.510896] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  882.510903] sd 7:0:0:0: [sdc] Sense not available.
[  882.510919] sd 7:0:0:0: [sdc] Write Protect is off
[  882.510924] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  882.510928] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  882.510985] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  882.510989] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  882.510997] sd 7:0:0:0: [sdc] Sense not available.
[  882.511012] sd 7:0:0:0: [sdc] Write Protect is off
[  882.511017] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  882.511022] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  884.507542] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  884.507551] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  884.507558] sd 7:0:0:0: [sdc] Sense not available.
[  884.507631] sd 7:0:0:0: [sdc] Write Protect is off
[  884.507636] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  884.507640] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  884.507702] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  884.507707] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  884.507714] sd 7:0:0:0: [sdc] Sense not available.
[  884.507729] sd 7:0:0:0: [sdc] Write Protect is off
[  884.507734] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  884.507739] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  886.504173] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  886.504181] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  886.504188] sd 7:0:0:0: [sdc] Sense not available.
[  886.504252] sd 7:0:0:0: [sdc] Write Protect is off
[  886.504257] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  886.504260] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  886.504321] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  886.504325] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  886.504333] sd 7:0:0:0: [sdc] Sense not available.
[  886.504349] sd 7:0:0:0: [sdc] Write Protect is off
[  886.504353] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  886.504358] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  888.500831] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  888.500840] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  888.500847] sd 7:0:0:0: [sdc] Sense not available.
[  888.500912] sd 7:0:0:0: [sdc] Write Protect is off
[  888.500917] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  888.500921] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  888.500983] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  888.500987] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  888.500993] sd 7:0:0:0: [sdc] Sense not available.
[  888.501008] sd 7:0:0:0: [sdc] Write Protect is off
[  888.501012] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  888.501016] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  890.498303] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  890.498314] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  890.498321] sd 7:0:0:0: [sdc] Sense not available.
[  890.498338] sd 7:0:0:0: [sdc] Write Protect is off
[  890.498342] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  890.498346] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  890.498404] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  890.498408] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  890.498415] sd 7:0:0:0: [sdc] Sense not available.
[  890.498430] sd 7:0:0:0: [sdc] Write Protect is off
[  890.498435] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  890.498439] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  892.494128] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  892.494137] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  892.494145] sd 7:0:0:0: [sdc] Sense not available.
[  892.494162] sd 7:0:0:0: [sdc] Write Protect is off
[  892.494166] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  892.494170] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  892.494381] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  892.494385] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  892.494392] sd 7:0:0:0: [sdc] Sense not available.
[  892.494425] sd 7:0:0:0: [sdc] Write Protect is off
[  892.494430] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  892.494434] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  894.494099] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  894.494108] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  894.494115] sd 7:0:0:0: [sdc] Sense not available.
[  894.494132] sd 7:0:0:0: [sdc] Write Protect is off
[  894.494136] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  894.494140] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  894.494196] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  894.494201] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  894.494209] sd 7:0:0:0: [sdc] Sense not available.
[  894.494224] sd 7:0:0:0: [sdc] Write Protect is off
[  894.494229] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  894.494233] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  896.490736] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  896.490746] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  896.490753] sd 7:0:0:0: [sdc] Sense not available.
[  896.490769] sd 7:0:0:0: [sdc] Write Protect is off
[  896.490773] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  896.490778] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  896.490836] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  896.490840] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  896.490847] sd 7:0:0:0: [sdc] Sense not available.
[  896.490862] sd 7:0:0:0: [sdc] Write Protect is off
[  896.490867] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  896.490871] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  898.487350] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  898.487359] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  898.487366] sd 7:0:0:0: [sdc] Sense not available.
[  898.487431] sd 7:0:0:0: [sdc] Write Protect is off
[  898.487435] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  898.487439] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  898.487499] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  898.487503] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  898.487512] sd 7:0:0:0: [sdc] Sense not available.
[  898.487527] sd 7:0:0:0: [sdc] Write Protect is off
[  898.487532] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  898.487536] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  900.484009] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  900.484018] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  900.484025] sd 7:0:0:0: [sdc] Sense not available.
[  900.484041] sd 7:0:0:0: [sdc] Write Protect is off
[  900.484047] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  900.484052] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  902.360484] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  902.360490] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  902.360498] sd 7:0:0:0: [sdc] Sense not available.
[  902.360514] sd 7:0:0:0: [sdc] Write Protect is off
[  902.360519] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  902.360524] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  904.357042] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  904.357052] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  904.357059] sd 7:0:0:0: [sdc] Sense not available.
[  904.357075] sd 7:0:0:0: [sdc] Write Protect is off
[  904.357081] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  904.357085] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  902.480832] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  902.480838] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  902.480846] sd 7:0:0:0: [sdc] Sense not available.
[  902.480862] sd 7:0:0:0: [sdc] Write Protect is off
[  902.480867] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  902.480872] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  904.477297] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  904.477306] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  904.477313] sd 7:0:0:0: [sdc] Sense not available.
[  904.477383] sd 7:0:0:0: [sdc] Write Protect is off
[  904.477388] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  904.477392] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  904.477452] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  904.477455] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  904.477464] sd 7:0:0:0: [sdc] Sense not available.
[  904.477479] sd 7:0:0:0: [sdc] Write Protect is off
[  904.477484] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  904.477488] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  906.473926] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  906.473936] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  906.473943] sd 7:0:0:0: [sdc] Sense not available.
[  906.473990] sd 7:0:0:0: [sdc] Write Protect is off
[  906.473994] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  906.473998] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  906.474335] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  906.474338] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  906.474344] sd 7:0:0:0: [sdc] Sense not available.
[  906.474473] sd 7:0:0:0: [sdc] Write Protect is off
[  906.474477] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  906.474481] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  908.470612] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  908.470622] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  908.470629] sd 7:0:0:0: [sdc] Sense not available.
[  908.470694] sd 7:0:0:0: [sdc] Write Protect is off
[  908.470699] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  908.470703] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  908.470763] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  908.470768] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  908.470776] sd 7:0:0:0: [sdc] Sense not available.
[  908.470792] sd 7:0:0:0: [sdc] Write Protect is off
[  908.470796] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  908.470801] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  910.467248] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  910.467257] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  910.467264] sd 7:0:0:0: [sdc] Sense not available.
[  910.467281] sd 7:0:0:0: [sdc] Write Protect is off
[  910.467287] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  910.467291] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  910.467350] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  910.467355] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  910.467363] sd 7:0:0:0: [sdc] Sense not available.
[  910.467378] sd 7:0:0:0: [sdc] Write Protect is off
[  910.467383] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  910.467387] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  912.463903] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  912.463913] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  912.463921] sd 7:0:0:0: [sdc] Sense not available.
[  912.463937] sd 7:0:0:0: [sdc] Write Protect is off
[  912.463941] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  912.463946] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  912.464005] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  912.464008] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  912.464016] sd 7:0:0:0: [sdc] Sense not available.
[  912.464032] sd 7:0:0:0: [sdc] Write Protect is off
[  912.464036] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  912.464041] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  914.460519] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  914.460528] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  914.460535] sd 7:0:0:0: [sdc] Sense not available.
[  914.460584] sd 7:0:0:0: [sdc] Write Protect is off
[  914.460589] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  914.460593] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  914.460909] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  914.460912] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  914.460918] sd 7:0:0:0: [sdc] Sense not available.
[  914.461061] sd 7:0:0:0: [sdc] Write Protect is off
[  914.461065] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  914.461068] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  916.457192] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  916.457202] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  916.457209] sd 7:0:0:0: [sdc] Sense not available.
[  916.457225] sd 7:0:0:0: [sdc] Write Protect is off
[  916.457230] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  916.457234] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  918.333704] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  918.333710] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  918.333718] sd 7:0:0:0: [sdc] Sense not available.
[  918.333734] sd 7:0:0:0: [sdc] Write Protect is off
[  918.333739] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  918.333744] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  920.330181] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  920.330190] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  920.330197] sd 7:0:0:0: [sdc] Sense not available.
[  920.330280] sd 7:0:0:0: [sdc] Write Protect is off
[  920.330285] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  920.330289] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  920.330351] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  920.330355] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  920.330363] sd 7:0:0:0: [sdc] Sense not available.
[  920.330378] sd 7:0:0:0: [sdc] Write Protect is off
[  920.330382] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  920.330387] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  922.327664] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  922.327673] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  922.327681] sd 7:0:0:0: [sdc] Sense not available.
[  922.327750] sd 7:0:0:0: [sdc] Write Protect is off
[  922.327754] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  922.327758] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  922.327817] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  922.327822] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  922.327830] sd 7:0:0:0: [sdc] Sense not available.
[  922.327845] sd 7:0:0:0: [sdc] Write Protect is off
[  922.327851] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  922.327855] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  924.324312] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  924.324322] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  924.324332] sd 7:0:0:0: [sdc] Sense not available.
[  924.324374] sd 7:0:0:0: [sdc] Write Protect is off
[  924.324378] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  924.324383] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  924.324534] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  924.324538] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  924.324546] sd 7:0:0:0: [sdc] Sense not available.
[  924.324576] sd 7:0:0:0: [sdc] Write Protect is off
[  924.324581] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  924.324586] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  926.320090] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  926.320100] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  926.320107] sd 7:0:0:0: [sdc] Sense not available.
[  924.444440] sd 7:0:0:0: [sdc] Write Protect is off
[  924.444447] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  924.444451] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  924.444528] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  924.444532] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  924.444540] sd 7:0:0:0: [sdc] Sense not available.
[  924.444555] sd 7:0:0:0: [sdc] Write Protect is off
[  924.444561] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  924.444565] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  926.440413] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  926.440422] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  926.440429] sd 7:0:0:0: [sdc] Sense not available.
[  926.441030] sd 7:0:0:0: [sdc] Write Protect is off
[  926.441036] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  926.441040] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  926.441537] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  926.441542] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  926.441550] sd 7:0:0:0: [sdc] Sense not available.
[  926.441566] sd 7:0:0:0: [sdc] Write Protect is off
[  926.441571] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  926.441575] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  928.437030] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  928.437040] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  928.437047] sd 7:0:0:0: [sdc] Sense not available.
[  928.437063] sd 7:0:0:0: [sdc] Write Protect is off
[  928.437069] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  928.437073] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  930.313507] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  930.313513] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  930.313521] sd 7:0:0:0: [sdc] Sense not available.
[  930.313537] sd 7:0:0:0: [sdc] Write Protect is off
[  930.313542] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  930.313547] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  932.317398] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  932.317407] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  932.317414] sd 7:0:0:0: [sdc] Sense not available.
[  932.317431] sd 7:0:0:0: [sdc] Write Protect is off
[  932.317435] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  932.317439] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  930.441188] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  930.441194] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  930.441202] sd 7:0:0:0: [sdc] Sense not available.
[  930.441218] sd 7:0:0:0: [sdc] Write Protect is off
[  930.441223] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  930.441228] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  932.436963] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  932.436973] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  932.436980] sd 7:0:0:0: [sdc] Sense not available.
[  934.313372] sd 7:0:0:0: [sdc] Write Protect is off
[  934.313378] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  934.313382] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  934.313456] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  934.313460] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  934.313469] sd 7:0:0:0: [sdc] Sense not available.
[  934.313484] sd 7:0:0:0: [sdc] Write Protect is off
[  934.313489] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  934.313494] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  936.309955] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  936.309964] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  936.309971] sd 7:0:0:0: [sdc] Sense not available.
[  936.310034] sd 7:0:0:0: [sdc] Write Protect is off
[  936.310039] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  936.310043] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  936.310103] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  936.310107] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  936.310115] sd 7:0:0:0: [sdc] Sense not available.
[  936.310131] sd 7:0:0:0: [sdc] Write Protect is off
[  936.310135] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  936.310140] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  938.306632] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  938.306642] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  938.306649] sd 7:0:0:0: [sdc] Sense not available.
[  938.306666] sd 7:0:0:0: [sdc] Write Protect is off
[  938.306671] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  938.306676] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  936.430427] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  936.430433] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  936.430441] sd 7:0:0:0: [sdc] Sense not available.
[  936.430457] sd 7:0:0:0: [sdc] Write Protect is off
[  936.430462] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  936.430467] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  938.426943] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  938.426953] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  938.426961] sd 7:0:0:0: [sdc] Sense not available.
[  938.426977] sd 7:0:0:0: [sdc] Write Protect is off
[  938.426981] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  938.426987] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  940.303444] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  940.303450] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  940.303458] sd 7:0:0:0: [sdc] Sense not available.
[  940.303475] sd 7:0:0:0: [sdc] Write Protect is off
[  940.303480] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  940.303484] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  942.303224] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  942.303233] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  942.303240] sd 7:0:0:0: [sdc] Sense not available.
[  942.303302] sd 7:0:0:0: [sdc] Write Protect is off
[  942.303306] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  942.303310] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  942.303370] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  942.303374] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  942.303381] sd 7:0:0:0: [sdc] Sense not available.
[  942.303397] sd 7:0:0:0: [sdc] Write Protect is off
[  942.303401] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  942.303406] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  944.299902] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  944.299912] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  944.299920] sd 7:0:0:0: [sdc] Sense not available.
[  944.299936] sd 7:0:0:0: [sdc] Write Protect is off
[  944.299940] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  944.299945] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  942.423705] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  942.423711] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  942.423719] sd 7:0:0:0: [sdc] Sense not available.
[  942.423735] sd 7:0:0:0: [sdc] Write Protect is off
[  942.423739] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  942.423744] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  944.420201] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  944.420211] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  944.420218] sd 7:0:0:0: [sdc] Sense not available.
[  944.420234] sd 7:0:0:0: [sdc] Write Protect is off
[  944.420238] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  944.420243] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  946.296702] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  946.296708] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  946.296716] sd 7:0:0:0: [sdc] Sense not available.
[  946.296732] sd 7:0:0:0: [sdc] Write Protect is off
[  946.296737] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  946.296742] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  948.296488] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  948.296497] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  948.296504] sd 7:0:0:0: [sdc] Sense not available.
[  948.296521] sd 7:0:0:0: [sdc] Write Protect is off
[  948.296526] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  948.296530] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  946.420297] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  946.420304] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  946.420312] sd 7:0:0:0: [sdc] Sense not available.
[  946.420328] sd 7:0:0:0: [sdc] Write Protect is off
[  946.420333] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  946.420338] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  948.416804] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  948.416813] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  948.416820] sd 7:0:0:0: [sdc] Sense not available.
[  948.416837] sd 7:0:0:0: [sdc] Write Protect is off
[  948.416841] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  948.416845] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  948.416901] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  948.416906] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  948.416914] sd 7:0:0:0: [sdc] Sense not available.
[  948.416929] sd 7:0:0:0: [sdc] Write Protect is off
[  948.416934] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  948.416938] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  952.289816] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  952.289825] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  952.289833] sd 7:0:0:0: [sdc] Sense not available.
[  952.289901] sd 7:0:0:0: [sdc] Write Protect is off
[  952.289906] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  952.289910] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  952.289970] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  952.289974] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  952.289982] sd 7:0:0:0: [sdc] Sense not available.
[  952.289997] sd 7:0:0:0: [sdc] Write Protect is off
[  952.290002] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  952.290006] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  954.291454] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  954.291464] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  954.291472] sd 7:0:0:0: [sdc] Sense not available.
[  954.291507] sd 7:0:0:0: [sdc] Write Protect is off
[  954.291513] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  954.291517] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  952.415282] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  952.415288] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  952.415296] sd 7:0:0:0: [sdc] Sense not available.
[  952.415312] sd 7:0:0:0: [sdc] Write Protect is off
[  952.415317] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  952.415322] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  954.413349] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  954.413358] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  954.413365] sd 7:0:0:0: [sdc] Sense not available.
[  954.413432] sd 7:0:0:0: [sdc] Write Protect is off
[  954.413436] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  954.413440] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  954.413500] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  954.413504] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  954.413512] sd 7:0:0:0: [sdc] Sense not available.
[  954.413528] sd 7:0:0:0: [sdc] Write Protect is off
[  954.413533] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  954.413537] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  956.410033] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  956.410043] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  956.410050] sd 7:0:0:0: [sdc] Sense not available.
[  956.410123] sd 7:0:0:0: [sdc] Write Protect is off
[  956.410128] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  956.410132] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  956.410193] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  956.410198] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  956.410205] sd 7:0:0:0: [sdc] Sense not available.
[  956.410220] sd 7:0:0:0: [sdc] Write Protect is off
[  956.410226] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  956.410230] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  958.406686] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  958.406696] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  958.406703] sd 7:0:0:0: [sdc] Sense not available.
[  960.283129] sd 7:0:0:0: [sdc] Write Protect is off
[  960.283136] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  960.283141] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  960.283262] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  960.283266] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  960.283275] sd 7:0:0:0: [sdc] Sense not available.
[  960.283484] sd 7:0:0:0: [sdc] Write Protect is off
[  960.283489] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  960.283494] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  962.279679] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  962.279689] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  962.279696] sd 7:0:0:0: [sdc] Sense not available.
[  962.279713] sd 7:0:0:0: [sdc] Write Protect is off
[  962.279717] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  962.279722] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  962.279852] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  962.279856] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  962.279865] sd 7:0:0:0: [sdc] Sense not available.
[  962.279893] sd 7:0:0:0: [sdc] Write Protect is off
[  962.279899] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  962.279903] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  964.276318] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  964.276329] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  964.276336] sd 7:0:0:0: [sdc] Sense not available.
[  964.276352] sd 7:0:0:0: [sdc] Write Protect is off
[  964.276357] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  964.276362] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  964.276472] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  964.276476] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  964.276484] sd 7:0:0:0: [sdc] Sense not available.
[  964.276557] sd 7:0:0:0: [sdc] Write Protect is off
[  964.276562] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  964.276567] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  966.273758] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  966.273767] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  966.273774] sd 7:0:0:0: [sdc] Sense not available.
[  966.273791] sd 7:0:0:0: [sdc] Write Protect is off
[  966.273795] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  966.273799] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  966.273935] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  966.273940] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  966.273947] sd 7:0:0:0: [sdc] Sense not available.
[  966.273975] sd 7:0:0:0: [sdc] Write Protect is off
[  966.273980] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  966.273984] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  968.269606] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  968.269616] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  968.269623] sd 7:0:0:0: [sdc] Sense not available.
[  968.269640] sd 7:0:0:0: [sdc] Write Protect is off
[  968.269645] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  968.269649] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  966.393442] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  966.393448] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  966.393457] sd 7:0:0:0: [sdc] Sense not available.
[  966.393473] sd 7:0:0:0: [sdc] Write Protect is off
[  966.393478] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  966.393483] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  968.389904] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  968.389914] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  968.389922] sd 7:0:0:0: [sdc] Sense not available.
[  968.389938] sd 7:0:0:0: [sdc] Write Protect is off
[  968.389942] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  968.389947] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  970.266386] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  970.266392] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  970.266400] sd 7:0:0:0: [sdc] Sense not available.
[  970.266416] sd 7:0:0:0: [sdc] Write Protect is off
[  970.266421] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  970.266425] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  972.262891] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  972.262901] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  972.262908] sd 7:0:0:0: [sdc] Sense not available.
[  972.262925] sd 7:0:0:0: [sdc] Write Protect is off
[  972.262929] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  972.262934] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  970.386685] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  970.386691] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  970.386700] sd 7:0:0:0: [sdc] Sense not available.
[  970.386716] sd 7:0:0:0: [sdc] Write Protect is off
[  970.386721] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  970.386726] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  972.386512] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  972.386521] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  972.386528] sd 7:0:0:0: [sdc] Sense not available.
[  972.386612] sd 7:0:0:0: [sdc] Write Protect is off
[  972.386616] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  972.386621] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  972.386683] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  972.386687] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  972.386695] sd 7:0:0:0: [sdc] Sense not available.
[  972.386710] sd 7:0:0:0: [sdc] Write Protect is off
[  972.386715] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  972.386719] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  974.383137] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  974.383146] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  974.383153] sd 7:0:0:0: [sdc] Sense not available.
[  974.383169] sd 7:0:0:0: [sdc] Write Protect is off
[  974.383175] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  974.383179] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  976.259612] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  976.259619] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  976.259626] sd 7:0:0:0: [sdc] Sense not available.
[  976.259642] sd 7:0:0:0: [sdc] Write Protect is off
[  976.259647] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  976.259652] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  978.256137] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  978.256147] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  978.256154] sd 7:0:0:0: [sdc] Sense not available.
[  978.256170] sd 7:0:0:0: [sdc] Write Protect is off
[  978.256175] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  978.256180] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  976.379931] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  976.379937] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  976.379945] sd 7:0:0:0: [sdc] Sense not available.
[  976.379960] sd 7:0:0:0: [sdc] Write Protect is off
[  976.379966] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  976.379971] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  978.376428] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  978.376437] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  978.376444] sd 7:0:0:0: [sdc] Sense not available.
[  978.376516] sd 7:0:0:0: [sdc] Write Protect is off
[  978.376521] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  978.376525] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  978.376585] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  978.376589] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  978.376597] sd 7:0:0:0: [sdc] Sense not available.
[  978.376613] sd 7:0:0:0: [sdc] Write Protect is off
[  978.376618] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  978.376622] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  980.373082] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  980.373091] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  980.373098] sd 7:0:0:0: [sdc] Sense not available.
[  980.373172] sd 7:0:0:0: [sdc] Write Protect is off
[  980.373177] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  980.373181] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  980.373242] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  980.373247] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  980.373255] sd 7:0:0:0: [sdc] Sense not available.
[  980.373270] sd 7:0:0:0: [sdc] Write Protect is off
[  980.373275] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  980.373280] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  982.369712] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  982.369721] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  982.369728] sd 7:0:0:0: [sdc] Sense not available.
[  982.369806] sd 7:0:0:0: [sdc] Write Protect is off
[  982.369810] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  982.369814] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  982.369875] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  982.369880] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  982.369888] sd 7:0:0:0: [sdc] Sense not available.
[  982.369903] sd 7:0:0:0: [sdc] Write Protect is off
[  982.369907] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  982.369912] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  984.367160] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  984.367169] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  984.367176] sd 7:0:0:0: [sdc] Sense not available.
[  984.367228] sd 7:0:0:0: [sdc] Write Protect is off
[  984.367233] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  984.367236] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  984.367296] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  984.367301] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  984.367310] sd 7:0:0:0: [sdc] Sense not available.
[  984.367325] sd 7:0:0:0: [sdc] Write Protect is off
[  984.367331] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  984.367335] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  986.362969] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  986.362978] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  986.362985] sd 7:0:0:0: [sdc] Sense not available.
[  986.363037] sd 7:0:0:0: [sdc] Write Protect is off
[  986.363042] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  986.363046] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  986.363105] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  986.363110] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  986.363117] sd 7:0:0:0: [sdc] Sense not available.
[  986.363133] sd 7:0:0:0: [sdc] Write Protect is off
[  986.363138] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  986.363142] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  988.359615] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  988.359624] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  988.359632] sd 7:0:0:0: [sdc] Sense not available.
[  988.359687] sd 7:0:0:0: [sdc] Write Protect is off
[  988.359692] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  988.359696] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  988.359755] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  988.359760] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  988.359768] sd 7:0:0:0: [sdc] Sense not available.
[  988.359783] sd 7:0:0:0: [sdc] Write Protect is off
[  988.359788] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  988.359792] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  990.356261] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  990.356270] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  990.356277] sd 7:0:0:0: [sdc] Sense not available.
[  990.356293] sd 7:0:0:0: [sdc] Write Protect is off
[  990.356299] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  990.356303] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  992.232759] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  992.232765] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  992.232773] sd 7:0:0:0: [sdc] Sense not available.
[  992.232788] sd 7:0:0:0: [sdc] Write Protect is off
[  992.232794] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  992.232798] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  994.232569] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  994.232578] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  994.232585] sd 7:0:0:0: [sdc] Sense not available.
[  994.232648] sd 7:0:0:0: [sdc] Write Protect is off
[  994.232652] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  994.232656] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  994.232717] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  994.232721] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  994.232729] sd 7:0:0:0: [sdc] Sense not available.
[  994.232744] sd 7:0:0:0: [sdc] Write Protect is off
[  994.232749] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  994.232753] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  996.229248] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  996.229258] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  996.229265] sd 7:0:0:0: [sdc] Sense not available.
[  996.229281] sd 7:0:0:0: [sdc] Write Protect is off
[  996.229286] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  996.229291] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  994.353043] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  994.353049] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  994.353057] sd 7:0:0:0: [sdc] Sense not available.
[  994.353073] sd 7:0:0:0: [sdc] Write Protect is off
[  994.353078] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  994.353083] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  996.349523] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  996.349532] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  996.349540] sd 7:0:0:0: [sdc] Sense not available.
[  996.349556] sd 7:0:0:0: [sdc] Write Protect is off
[  996.349561] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  996.349566] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  998.225999] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  998.226005] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  998.226013] sd 7:0:0:0: [sdc] Sense not available.
[  998.226028] sd 7:0:0:0: [sdc] Write Protect is off
[  998.226033] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  998.226037] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1000.223364] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1000.223372] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1000.223379] sd 7:0:0:0: [sdc] Sense not available.
[ 1000.223396] sd 7:0:0:0: [sdc] Write Protect is off
[ 1000.223402] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1000.223405] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  998.347167] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  998.347172] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  998.347180] sd 7:0:0:0: [sdc] Sense not available.
[  998.347196] sd 7:0:0:0: [sdc] Write Protect is off
[  998.347202] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  998.347206] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1000.342801] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1000.342810] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1000.342817] sd 7:0:0:0: [sdc] Sense not available.
[ 1000.342834] sd 7:0:0:0: [sdc] Write Protect is off
[ 1000.342840] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1000.342844] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1000.342900] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1000.342904] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1000.342913] sd 7:0:0:0: [sdc] Sense not available.
[ 1000.342928] sd 7:0:0:0: [sdc] Write Protect is off
[ 1000.342933] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1000.342938] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1002.339448] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1002.339457] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1002.339464] sd 7:0:0:0: [sdc] Sense not available.
[ 1002.339529] sd 7:0:0:0: [sdc] Write Protect is off
[ 1002.339533] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1002.339537] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1002.339597] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1002.339601] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1002.339610] sd 7:0:0:0: [sdc] Sense not available.
[ 1002.339626] sd 7:0:0:0: [sdc] Write Protect is off
[ 1002.339631] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1002.339635] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1004.336118] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1004.336127] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1004.336134] sd 7:0:0:0: [sdc] Sense not available.
[ 1006.212587] sd 7:0:0:0: [sdc] Write Protect is off
[ 1006.212594] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1006.212598] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1006.212674] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1006.212678] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1006.212687] sd 7:0:0:0: [sdc] Sense not available.
[ 1006.212702] sd 7:0:0:0: [sdc] Write Protect is off
[ 1006.212707] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1006.212712] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1008.209106] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1008.209115] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1008.209122] sd 7:0:0:0: [sdc] Sense not available.
[ 1008.209189] sd 7:0:0:0: [sdc] Write Protect is off
[ 1008.209193] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1008.209197] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1008.209259] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1008.209263] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1008.209272] sd 7:0:0:0: [sdc] Sense not available.
[ 1008.209287] sd 7:0:0:0: [sdc] Write Protect is off
[ 1008.209292] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1008.209296] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1010.215753] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1010.215762] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1010.215769] sd 7:0:0:0: [sdc] Sense not available.
[ 1010.215784] sd 7:0:0:0: [sdc] Write Protect is off
[ 1010.215789] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1010.215793] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1008.339590] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1008.339595] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1008.339602] sd 7:0:0:0: [sdc] Sense not available.
[ 1008.339628] sd 7:0:0:0: [sdc] Write Protect is off
[ 1008.339634] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1008.339638] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1010.336093] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1010.336103] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1010.336110] sd 7:0:0:0: [sdc] Sense not available.
[ 1010.336201] sd 7:0:0:0: [sdc] Write Protect is off
[ 1010.336206] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1010.336209] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1010.336270] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1010.336275] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1010.336283] sd 7:0:0:0: [sdc] Sense not available.
[ 1010.336298] sd 7:0:0:0: [sdc] Write Protect is off
[ 1010.336303] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1010.336307] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1012.332717] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1012.332726] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1012.332733] sd 7:0:0:0: [sdc] Sense not available.
[ 1012.332816] sd 7:0:0:0: [sdc] Write Protect is off
[ 1012.332820] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1012.332824] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1012.332885] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1012.332889] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1012.332898] sd 7:0:0:0: [sdc] Sense not available.
[ 1012.332914] sd 7:0:0:0: [sdc] Write Protect is off
[ 1012.332919] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1012.332924] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1014.329384] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1014.329393] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1014.329401] sd 7:0:0:0: [sdc] Sense not available.
[ 1016.205815] sd 7:0:0:0: [sdc] Write Protect is off
[ 1016.205822] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1016.205827] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1014.329632] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1014.329636] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1014.329644] sd 7:0:0:0: [sdc] Sense not available.
[ 1014.329660] sd 7:0:0:0: [sdc] Write Protect is off
[ 1014.329665] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1014.329670] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1016.326194] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1016.326204] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1016.326212] sd 7:0:0:0: [sdc] Sense not available.
[ 1016.326229] sd 7:0:0:0: [sdc] Write Protect is off
[ 1016.326234] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1016.326238] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1018.202709] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1018.202715] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1018.202723] sd 7:0:0:0: [sdc] Sense not available.
[ 1018.202739] sd 7:0:0:0: [sdc] Write Protect is off
[ 1018.202744] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1018.202749] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1018.323468] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1018.323477] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1018.323484] sd 7:0:0:0: [sdc] Sense not available.
[ 1018.323549] sd 7:0:0:0: [sdc] Write Protect is off
[ 1018.323553] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1018.323557] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1018.323618] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1018.323622] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1018.323630] sd 7:0:0:0: [sdc] Sense not available.
[ 1018.323645] sd 7:0:0:0: [sdc] Write Protect is off
[ 1018.323649] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1018.323654] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1022.195714] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1022.195723] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1022.195730] sd 7:0:0:0: [sdc] Sense not available.
[ 1022.195806] sd 7:0:0:0: [sdc] Write Protect is off
[ 1022.195811] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1022.195815] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1022.195878] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1022.195883] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1022.195891] sd 7:0:0:0: [sdc] Sense not available.
[ 1022.195907] sd 7:0:0:0: [sdc] Write Protect is off
[ 1022.195912] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1022.195916] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1024.192327] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1024.192337] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1024.192344] sd 7:0:0:0: [sdc] Sense not available.
[ 1024.192360] sd 7:0:0:0: [sdc] Write Protect is off
[ 1024.192364] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1024.192368] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1022.316176] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1022.316181] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1022.316187] sd 7:0:0:0: [sdc] Sense not available.
[ 1022.316215] sd 7:0:0:0: [sdc] Write Protect is off
[ 1022.316220] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1022.316224] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1024.312766] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1024.312776] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1024.312783] sd 7:0:0:0: [sdc] Sense not available.
[ 1024.312800] sd 7:0:0:0: [sdc] Write Protect is off
[ 1024.312805] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1024.312810] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1026.189250] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1026.189255] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1026.189263] sd 7:0:0:0: [sdc] Sense not available.
[ 1026.189279] sd 7:0:0:0: [sdc] Write Protect is off
[ 1026.189284] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1026.189289] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1028.186621] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1028.186629] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1028.186636] sd 7:0:0:0: [sdc] Sense not available.
[ 1028.186703] sd 7:0:0:0: [sdc] Write Protect is off
[ 1028.186707] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1028.186711] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1028.186771] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1028.186776] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1028.186784] sd 7:0:0:0: [sdc] Sense not available.
[ 1028.186800] sd 7:0:0:0: [sdc] Write Protect is off
[ 1028.186804] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1028.186809] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1030.186277] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1030.186287] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1030.186294] sd 7:0:0:0: [sdc] Sense not available.
[ 1030.186310] sd 7:0:0:0: [sdc] Write Protect is off
[ 1030.186315] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1030.186319] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1028.310098] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1028.310105] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1028.310113] sd 7:0:0:0: [sdc] Sense not available.
[ 1028.310129] sd 7:0:0:0: [sdc] Write Protect is off
[ 1028.310134] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1028.310139] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1030.305806] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1030.305815] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1030.305823] sd 7:0:0:0: [sdc] Sense not available.
[ 1030.305845] sd 7:0:0:0: [sdc] Write Protect is off
[ 1030.305850] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1030.305854] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1030.305913] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1030.305917] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1030.305925] sd 7:0:0:0: [sdc] Sense not available.
[ 1030.305941] sd 7:0:0:0: [sdc] Write Protect is off
[ 1030.305945] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1030.305949] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1032.306237] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1032.306245] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1032.306253] sd 7:0:0:0: [sdc] Sense not available.
[ 1032.306269] sd 7:0:0:0: [sdc] Write Protect is off
[ 1032.306274] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1032.306278] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1034.182725] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1034.182731] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1034.182739] sd 7:0:0:0: [sdc] Sense not available.
[ 1034.182754] sd 7:0:0:0: [sdc] Write Protect is off
[ 1034.182760] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1034.182765] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1036.178733] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1036.178743] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1036.178753] sd 7:0:0:0: [sdc] Sense not available.
[ 1036.178779] sd 7:0:0:0: [sdc] Write Protect is off
[ 1036.178784] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1036.178789] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1034.302570] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1034.302577] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1034.302585] sd 7:0:0:0: [sdc] Sense not available.
[ 1034.302601] sd 7:0:0:0: [sdc] Write Protect is off
[ 1034.302606] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1034.302611] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1036.299125] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1036.299135] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1036.299142] sd 7:0:0:0: [sdc] Sense not available.
[ 1036.299159] sd 7:0:0:0: [sdc] Write Protect is off
[ 1036.299163] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1036.299167] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1038.175654] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1038.175659] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1038.175667] sd 7:0:0:0: [sdc] Sense not available.
[ 1038.175683] sd 7:0:0:0: [sdc] Write Protect is off
[ 1038.175688] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1038.175693] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1038.295683] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1038.295692] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1038.295700] sd 7:0:0:0: [sdc] Sense not available.
[ 1038.295716] sd 7:0:0:0: [sdc] Write Protect is off
[ 1038.295721] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1038.295725] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1040.172172] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1040.172177] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1040.172185] sd 7:0:0:0: [sdc] Sense not available.
[ 1040.172201] sd 7:0:0:0: [sdc] Write Protect is off
[ 1040.172207] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1040.172211] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1042.168753] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1042.168761] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1042.168768] sd 7:0:0:0: [sdc] Sense not available.
[ 1042.168834] sd 7:0:0:0: [sdc] Write Protect is off
[ 1042.168838] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1042.168842] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1042.168903] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1042.168907] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1042.168916] sd 7:0:0:0: [sdc] Sense not available.
[ 1042.168931] sd 7:0:0:0: [sdc] Write Protect is off
[ 1042.168936] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1042.168940] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1044.165251] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1044.165259] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1044.165267] sd 7:0:0:0: [sdc] Sense not available.
[ 1044.165283] sd 7:0:0:0: [sdc] Write Protect is off
[ 1044.165287] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1044.165291] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1042.289093] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1042.289100] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1042.289107] sd 7:0:0:0: [sdc] Sense not available.
[ 1042.289123] sd 7:0:0:0: [sdc] Write Protect is off
[ 1042.289128] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1042.289133] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1044.285555] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1044.285563] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1044.285570] sd 7:0:0:0: [sdc] Sense not available.
[ 1044.285634] sd 7:0:0:0: [sdc] Write Protect is off
[ 1044.285638] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1044.285642] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1044.285702] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1044.285706] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1044.285713] sd 7:0:0:0: [sdc] Sense not available.
[ 1044.285729] sd 7:0:0:0: [sdc] Write Protect is off
[ 1044.285735] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1044.285739] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1046.282275] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1046.282283] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1046.282290] sd 7:0:0:0: [sdc] Sense not available.
[ 1046.282888] sd 7:0:0:0: [sdc] Write Protect is off
[ 1046.282894] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1046.282898] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1046.283270] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1046.283275] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1046.283282] sd 7:0:0:0: [sdc] Sense not available.
[ 1046.283298] sd 7:0:0:0: [sdc] Write Protect is off
[ 1046.283303] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1046.283307] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1048.278920] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1048.278930] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1048.278937] sd 7:0:0:0: [sdc] Sense not available.
[ 1048.278953] sd 7:0:0:0: [sdc] Write Protect is off
[ 1048.278958] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1048.278962] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1050.155460] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1050.155465] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1050.155473] sd 7:0:0:0: [sdc] Sense not available.
[ 1050.155489] sd 7:0:0:0: [sdc] Write Protect is off
[ 1050.155495] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1050.155499] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1052.151820] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1052.151830] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1052.151837] sd 7:0:0:0: [sdc] Sense not available.
[ 1052.151854] sd 7:0:0:0: [sdc] Write Protect is off
[ 1052.151859] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1052.151862] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1052.151920] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1052.151924] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1052.151933] sd 7:0:0:0: [sdc] Sense not available.
[ 1052.151948] sd 7:0:0:0: [sdc] Write Protect is off
[ 1052.151953] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1052.151957] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1054.149493] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1054.149498] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1054.149505] sd 7:0:0:0: [sdc] Sense not available.
[ 1054.149513] sd 7:0:0:0: [sdc] Write Protect is off
[ 1054.149515] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1054.149517] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1054.149627] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1054.149630] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1054.149635] sd 7:0:0:0: [sdc] Sense not available.
[ 1054.149758] sd 7:0:0:0: [sdc] Write Protect is off
[ 1054.149761] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1054.149763] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1056.145104] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1056.145113] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1056.145120] sd 7:0:0:0: [sdc] Sense not available.
[ 1056.145206] sd 7:0:0:0: [sdc] Write Protect is off
[ 1056.145210] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1056.145214] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1056.145273] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1056.145278] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1056.145285] sd 7:0:0:0: [sdc] Sense not available.
[ 1056.145301] sd 7:0:0:0: [sdc] Write Protect is off
[ 1056.145305] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1056.145310] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1056.265421] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1056.265430] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1056.265437] sd 7:0:0:0: [sdc] Sense not available.
[ 1056.265454] sd 7:0:0:0: [sdc] Write Protect is off
[ 1056.265459] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1056.265463] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1058.141891] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1058.141896] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1058.141904] sd 7:0:0:0: [sdc] Sense not available.
[ 1058.141919] sd 7:0:0:0: [sdc] Write Protect is off
[ 1058.141924] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1058.141929] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1060.138401] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1060.138411] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1060.138419] sd 7:0:0:0: [sdc] Sense not available.
[ 1060.138437] sd 7:0:0:0: [sdc] Write Protect is off
[ 1060.138442] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1060.138447] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1058.262240] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1058.262246] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1058.262254] sd 7:0:0:0: [sdc] Sense not available.
[ 1058.262270] sd 7:0:0:0: [sdc] Write Protect is off
[ 1058.262275] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1058.262280] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1060.258772] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1060.258782] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1060.258789] sd 7:0:0:0: [sdc] Sense not available.
[ 1060.258805] sd 7:0:0:0: [sdc] Write Protect is off
[ 1060.258811] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1060.258814] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1062.135276] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1062.135282] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1062.135290] sd 7:0:0:0: [sdc] Sense not available.
[ 1062.135306] sd 7:0:0:0: [sdc] Write Protect is off
[ 1062.135311] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1062.135316] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1064.131691] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1064.131700] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1064.131707] sd 7:0:0:0: [sdc] Sense not available.
[ 1064.131784] sd 7:0:0:0: [sdc] Write Protect is off
[ 1064.131788] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1064.131792] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1064.131853] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1064.131857] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1064.131865] sd 7:0:0:0: [sdc] Sense not available.
[ 1064.131880] sd 7:0:0:0: [sdc] Write Protect is off
[ 1064.131884] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1064.131889] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1066.131592] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1066.131601] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1066.131608] sd 7:0:0:0: [sdc] Sense not available.
[ 1066.132204] sd 7:0:0:0: [sdc] Write Protect is off
[ 1066.132210] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1066.132214] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1066.134321] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1066.134327] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1066.134335] sd 7:0:0:0: [sdc] Sense not available.
[ 1066.134350] sd 7:0:0:0: [sdc] Write Protect is off
[ 1066.134355] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1066.134360] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1068.129072] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1068.129081] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1068.129088] sd 7:0:0:0: [sdc] Sense not available.
[ 1068.129138] sd 7:0:0:0: [sdc] Write Protect is off
[ 1068.129142] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1068.129146] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1068.129368] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1068.129371] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1068.129377] sd 7:0:0:0: [sdc] Sense not available.
[ 1068.129408] sd 7:0:0:0: [sdc] Write Protect is off
[ 1068.129412] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1068.129415] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1070.124929] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1070.124939] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1070.124946] sd 7:0:0:0: [sdc] Sense not available.
[ 1070.124963] sd 7:0:0:0: [sdc] Write Protect is off
[ 1070.124967] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1070.124972] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1068.248796] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1068.248803] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1068.248811] sd 7:0:0:0: [sdc] Sense not available.
[ 1068.248827] sd 7:0:0:0: [sdc] Write Protect is off
[ 1068.248832] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1068.248837] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1070.245224] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1070.245234] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1070.245241] sd 7:0:0:0: [sdc] Sense not available.
[ 1070.245257] sd 7:0:0:0: [sdc] Write Protect is off
[ 1070.245263] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1070.245268] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1072.121707] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1072.121713] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1072.121721] sd 7:0:0:0: [sdc] Sense not available.
[ 1072.121738] sd 7:0:0:0: [sdc] Write Protect is off
[ 1072.121743] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1072.121747] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1074.119002] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1074.119011] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1074.119018] sd 7:0:0:0: [sdc] Sense not available.
[ 1074.119090] sd 7:0:0:0: [sdc] Write Protect is off
[ 1074.119094] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1074.119098] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1074.119158] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1074.119162] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1074.119171] sd 7:0:0:0: [sdc] Sense not available.
[ 1074.119186] sd 7:0:0:0: [sdc] Write Protect is off
[ 1074.119190] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1074.119194] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1076.114846] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1076.114855] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1076.114862] sd 7:0:0:0: [sdc] Sense not available.
[ 1076.114934] sd 7:0:0:0: [sdc] Write Protect is off
[ 1076.114939] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1076.114943] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1076.115005] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1076.115009] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1076.115017] sd 7:0:0:0: [sdc] Sense not available.
[ 1076.115032] sd 7:0:0:0: [sdc] Write Protect is off
[ 1076.115037] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1076.115041] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1078.111486] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1078.111495] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1078.111502] sd 7:0:0:0: [sdc] Sense not available.
[ 1078.111578] sd 7:0:0:0: [sdc] Write Protect is off
[ 1078.111582] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1078.111586] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1078.111650] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1078.111654] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1078.111661] sd 7:0:0:0: [sdc] Sense not available.
[ 1078.111676] sd 7:0:0:0: [sdc] Write Protect is off
[ 1078.111681] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1078.111686] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1080.108910] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1080.108920] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1080.108927] sd 7:0:0:0: [sdc] Sense not available.
[ 1080.108945] sd 7:0:0:0: [sdc] Write Protect is off
[ 1080.108950] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1080.108955] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1080.109013] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1080.109017] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1080.109025] sd 7:0:0:0: [sdc] Sense not available.
[ 1080.109040] sd 7:0:0:0: [sdc] Write Protect is off
[ 1080.109045] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1080.109049] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1082.105553] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1082.105561] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1082.105569] sd 7:0:0:0: [sdc] Sense not available.
[ 1082.105643] sd 7:0:0:0: [sdc] Write Protect is off
[ 1082.105647] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1082.105651] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1082.105712] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1082.105716] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1082.105725] sd 7:0:0:0: [sdc] Sense not available.
[ 1082.105740] sd 7:0:0:0: [sdc] Write Protect is off
[ 1082.105745] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1082.105749] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1084.101423] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1084.101433] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1084.101440] sd 7:0:0:0: [sdc] Sense not available.
[ 1084.101457] sd 7:0:0:0: [sdc] Write Protect is off
[ 1084.101462] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1084.101466] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1082.225238] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1082.225244] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1082.225252] sd 7:0:0:0: [sdc] Sense not available.
[ 1082.225268] sd 7:0:0:0: [sdc] Write Protect is off
[ 1082.225273] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1082.225278] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1084.221659] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1084.221668] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1084.221675] sd 7:0:0:0: [sdc] Sense not available.
[ 1084.221728] sd 7:0:0:0: [sdc] Write Protect is off
[ 1084.221732] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1084.221736] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1084.221795] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1084.221800] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1084.221807] sd 7:0:0:0: [sdc] Sense not available.
[ 1084.221822] sd 7:0:0:0: [sdc] Write Protect is off
[ 1084.221827] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1084.221831] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1086.218308] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1086.218317] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1086.218325] sd 7:0:0:0: [sdc] Sense not available.
[ 1086.218341] sd 7:0:0:0: [sdc] Write Protect is off
[ 1086.218346] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1086.218350] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1088.094834] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1088.094840] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1088.094848] sd 7:0:0:0: [sdc] Sense not available.
[ 1088.094864] sd 7:0:0:0: [sdc] Write Protect is off
[ 1088.094869] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1088.094873] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1090.091317] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1090.091327] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1090.091334] sd 7:0:0:0: [sdc] Sense not available.
[ 1090.091351] sd 7:0:0:0: [sdc] Write Protect is off
[ 1090.091357] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1090.091361] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1090.091419] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1090.091424] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1090.091431] sd 7:0:0:0: [sdc] Sense not available.
[ 1090.091447] sd 7:0:0:0: [sdc] Write Protect is off
[ 1090.091451] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1090.091455] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1092.087965] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1092.087974] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1092.087981] sd 7:0:0:0: [sdc] Sense not available.
[ 1092.088058] sd 7:0:0:0: [sdc] Write Protect is off
[ 1092.088062] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1092.088066] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1092.088130] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1092.088134] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1092.088142] sd 7:0:0:0: [sdc] Sense not available.
[ 1092.088157] sd 7:0:0:0: [sdc] Write Protect is off
[ 1092.088162] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1092.088166] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1094.084601] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1094.084611] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1094.084618] sd 7:0:0:0: [sdc] Sense not available.
[ 1094.084634] sd 7:0:0:0: [sdc] Write Protect is off
[ 1094.084639] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1094.084644] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1092.208411] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1092.208417] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1092.208425] sd 7:0:0:0: [sdc] Sense not available.
[ 1092.208441] sd 7:0:0:0: [sdc] Write Protect is off
[ 1092.208446] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1092.208450] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1094.204898] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1094.204907] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1094.204914] sd 7:0:0:0: [sdc] Sense not available.
[ 1096.081340] sd 7:0:0:0: [sdc] Write Protect is off
[ 1096.081347] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1096.081352] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1094.205131] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1094.205135] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1094.205143] sd 7:0:0:0: [sdc] Sense not available.
[ 1094.205159] sd 7:0:0:0: [sdc] Write Protect is off
[ 1094.205164] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1094.205169] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1096.201535] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1096.201544] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1096.201551] sd 7:0:0:0: [sdc] Sense not available.
[ 1096.201629] sd 7:0:0:0: [sdc] Write Protect is off
[ 1096.201634] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1096.201638] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1096.201700] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1096.201704] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1096.201712] sd 7:0:0:0: [sdc] Sense not available.
[ 1096.201728] sd 7:0:0:0: [sdc] Write Protect is off
[ 1096.201734] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1096.201738] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1098.198174] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1098.198183] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1098.198190] sd 7:0:0:0: [sdc] Sense not available.
[ 1098.198798] sd 7:0:0:0: [sdc] Write Protect is off
[ 1098.198804] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1098.198808] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1100.075689] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1100.075695] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1100.075703] sd 7:0:0:0: [sdc] Sense not available.
[ 1100.075735] sd 7:0:0:0: [sdc] Write Protect is off
[ 1100.075741] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1100.075745] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1102.071160] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1102.071170] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1102.071177] sd 7:0:0:0: [sdc] Sense not available.
[ 1102.071193] sd 7:0:0:0: [sdc] Write Protect is off
[ 1102.071199] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1102.071203] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1100.194951] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1100.194956] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1100.194964] sd 7:0:0:0: [sdc] Sense not available.
[ 1100.194980] sd 7:0:0:0: [sdc] Write Protect is off
[ 1100.194985] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1100.194990] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1102.194628] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1102.194637] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1102.194644] sd 7:0:0:0: [sdc] Sense not available.
[ 1102.195237] sd 7:0:0:0: [sdc] Write Protect is off
[ 1102.195243] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1102.195247] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1102.195796] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1102.195801] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1102.195809] sd 7:0:0:0: [sdc] Sense not available.
[ 1102.195825] sd 7:0:0:0: [sdc] Write Protect is off
[ 1102.195830] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1102.195834] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1104.188048] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1104.188056] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1104.188063] sd 7:0:0:0: [sdc] Sense not available.
[ 1104.188080] sd 7:0:0:0: [sdc] Write Protect is off
[ 1104.188085] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1104.188089] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1104.188146] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1104.188151] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1104.188158] sd 7:0:0:0: [sdc] Sense not available.
[ 1104.188173] sd 7:0:0:0: [sdc] Write Protect is off
[ 1104.188178] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1104.188182] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1106.184692] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1106.184701] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1106.184708] sd 7:0:0:0: [sdc] Sense not available.
[ 1106.184724] sd 7:0:0:0: [sdc] Write Protect is off
[ 1106.184730] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1106.184734] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1108.061168] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1108.061174] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1108.061182] sd 7:0:0:0: [sdc] Sense not available.
[ 1108.061198] sd 7:0:0:0: [sdc] Write Protect is off
[ 1108.061203] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1108.061207] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1108.191591] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1108.191601] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1108.191608] sd 7:0:0:0: [sdc] Sense not available.
[ 1108.191624] sd 7:0:0:0: [sdc] Write Protect is off
[ 1108.191628] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1108.191632] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1110.068088] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1110.068094] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1110.068102] sd 7:0:0:0: [sdc] Sense not available.
[ 1110.068118] sd 7:0:0:0: [sdc] Write Protect is off
[ 1110.068123] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1110.068127] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1112.064330] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1112.064340] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1112.064347] sd 7:0:0:0: [sdc] Sense not available.
[ 1112.064448] sd 7:0:0:0: [sdc] Write Protect is off
[ 1112.064453] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1112.064459] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1112.065747] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1112.065752] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1112.065760] sd 7:0:0:0: [sdc] Sense not available.
[ 1112.065776] sd 7:0:0:0: [sdc] Write Protect is off
[ 1112.065781] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1112.065785] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1114.060953] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1114.060962] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1114.060978] sd 7:0:0:0: [sdc] Sense not available.
[ 1114.061092] sd 7:0:0:0: [sdc] Write Protect is off
[ 1114.061097] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1114.061102] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1114.061162] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1114.061166] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1114.061175] sd 7:0:0:0: [sdc] Sense not available.
[ 1114.061189] sd 7:0:0:0: [sdc] Write Protect is off
[ 1114.061194] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1114.061197] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1116.057596] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1116.057607] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1116.057614] sd 7:0:0:0: [sdc] Sense not available.
[ 1116.057631] sd 7:0:0:0: [sdc] Write Protect is off
[ 1116.057635] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1116.057639] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1116.057726] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1116.057730] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1116.057736] sd 7:0:0:0: [sdc] Sense not available.
[ 1114.181428] sd 7:0:0:0: [sdc] Write Protect is off
[ 1114.181434] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1114.181438] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1116.177883] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1116.177892] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1116.177899] sd 7:0:0:0: [sdc] Sense not available.
[ 1116.178525] sd 7:0:0:0: [sdc] Write Protect is off
[ 1116.178539] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1116.178543] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1116.179041] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1116.179045] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1116.179053] sd 7:0:0:0: [sdc] Sense not available.
[ 1116.179069] sd 7:0:0:0: [sdc] Write Protect is off
[ 1116.179074] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1116.179078] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1118.174543] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1118.174553] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1118.174560] sd 7:0:0:0: [sdc] Sense not available.
[ 1118.174577] sd 7:0:0:0: [sdc] Write Protect is off
[ 1118.174582] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1118.174587] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1118.174786] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1118.174790] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1118.174798] sd 7:0:0:0: [sdc] Sense not available.
[ 1118.174832] sd 7:0:0:0: [sdc] Write Protect is off
[ 1118.174837] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1118.174842] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1120.171197] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1120.171206] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1120.171213] sd 7:0:0:0: [sdc] Sense not available.
[ 1120.171268] sd 7:0:0:0: [sdc] Write Protect is off
[ 1120.171272] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1120.171276] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1120.171337] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1120.171341] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1120.171349] sd 7:0:0:0: [sdc] Sense not available.
[ 1120.171365] sd 7:0:0:0: [sdc] Write Protect is off
[ 1120.171369] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1120.171374] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1122.167830] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1122.167839] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1122.167846] sd 7:0:0:0: [sdc] Sense not available.
[ 1122.167863] sd 7:0:0:0: [sdc] Write Protect is off
[ 1122.167867] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1122.167872] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1122.167929] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1122.167933] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1122.167940] sd 7:0:0:0: [sdc] Sense not available.
[ 1122.167955] sd 7:0:0:0: [sdc] Write Protect is off
[ 1122.167960] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1122.167965] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1124.164428] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1124.164437] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1124.164444] sd 7:0:0:0: [sdc] Sense not available.
[ 1124.164512] sd 7:0:0:0: [sdc] Write Protect is off
[ 1124.164516] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1124.164520] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1124.164620] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1124.164624] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1124.164632] sd 7:0:0:0: [sdc] Sense not available.
[ 1124.164647] sd 7:0:0:0: [sdc] Write Protect is off
[ 1124.164652] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1124.164657] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1126.161085] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1126.161095] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1126.161102] sd 7:0:0:0: [sdc] Sense not available.
[ 1126.161119] sd 7:0:0:0: [sdc] Write Protect is off
[ 1126.161124] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1126.161129] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1126.161187] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1126.161191] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1126.161198] sd 7:0:0:0: [sdc] Sense not available.
[ 1126.161214] sd 7:0:0:0: [sdc] Write Protect is off
[ 1126.161219] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1126.161223] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1128.157688] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1128.157697] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1128.157704] sd 7:0:0:0: [sdc] Sense not available.
[ 1128.157797] sd 7:0:0:0: [sdc] Write Protect is off
[ 1128.157801] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1128.157805] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1128.158735] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1128.158739] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1128.158748] sd 7:0:0:0: [sdc] Sense not available.
[ 1128.158765] sd 7:0:0:0: [sdc] Write Protect is off
[ 1128.158770] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1128.158775] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1130.154329] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1130.154338] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1130.154346] sd 7:0:0:0: [sdc] Sense not available.
[ 1130.154362] sd 7:0:0:0: [sdc] Write Protect is off
[ 1130.154366] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1130.154370] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1130.154448] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1130.154453] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1130.154460] sd 7:0:0:0: [sdc] Sense not available.
[ 1130.154491] sd 7:0:0:0: [sdc] Write Protect is off
[ 1130.154496] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1130.154501] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1132.151015] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1132.151025] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1132.151033] sd 7:0:0:0: [sdc] Sense not available.
[ 1132.151050] sd 7:0:0:0: [sdc] Write Protect is off
[ 1132.151054] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1132.151058] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1134.027522] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1134.027528] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1134.027536] sd 7:0:0:0: [sdc] Sense not available.
[ 1134.027552] sd 7:0:0:0: [sdc] Write Protect is off
[ 1134.027558] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1134.027563] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1136.024030] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1136.024038] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1136.024046] sd 7:0:0:0: [sdc] Sense not available.
[ 1136.024097] sd 7:0:0:0: [sdc] Write Protect is off
[ 1136.024101] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1136.024105] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1136.024545] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1136.024548] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1136.024554] sd 7:0:0:0: [sdc] Sense not available.
[ 1136.024578] sd 7:0:0:0: [sdc] Write Protect is off
[ 1136.024582] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1136.024586] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1138.020835] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1138.020845] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1138.020854] sd 7:0:0:0: [sdc] Sense not available.
[ 1138.020902] sd 7:0:0:0: [sdc] Write Protect is off
[ 1138.020908] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1138.020913] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1136.144669] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1136.144675] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1136.144683] sd 7:0:0:0: [sdc] Sense not available.
[ 1136.144698] sd 7:0:0:0: [sdc] Write Protect is off
[ 1136.144704] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1136.144709] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1138.141018] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1138.141028] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1138.141035] sd 7:0:0:0: [sdc] Sense not available.
[ 1138.141052] sd 7:0:0:0: [sdc] Write Protect is off
[ 1138.141056] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1138.141061] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1138.141191] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1138.141196] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1138.141204] sd 7:0:0:0: [sdc] Sense not available.
[ 1138.141235] sd 7:0:0:0: [sdc] Write Protect is off
[ 1138.141241] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1138.141245] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1140.137636] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1140.137647] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1140.137654] sd 7:0:0:0: [sdc] Sense not available.
[ 1140.137673] sd 7:0:0:0: [sdc] Write Protect is off
[ 1140.137679] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1140.137684] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1140.137817] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1140.137821] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1140.137829] sd 7:0:0:0: [sdc] Sense not available.
[ 1140.137857] sd 7:0:0:0: [sdc] Write Protect is off
[ 1140.137862] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1140.137866] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1142.134163] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1142.134172] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1142.134179] sd 7:0:0:0: [sdc] Sense not available.
[ 1142.134245] sd 7:0:0:0: [sdc] Write Protect is off
[ 1142.134249] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1142.134253] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1142.134312] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1142.134316] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1142.134324] sd 7:0:0:0: [sdc] Sense not available.
[ 1142.134339] sd 7:0:0:0: [sdc] Write Protect is off
[ 1142.134344] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1142.134349] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1144.130718] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1144.130723] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1144.130727] sd 7:0:0:0: [sdc] Sense not available.
[ 1144.130735] sd 7:0:0:0: [sdc] Write Protect is off
[ 1144.130737] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1144.130741] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1146.007139] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1146.007141] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1146.007145] sd 7:0:0:0: [sdc] Sense not available.
[ 1146.007153] sd 7:0:0:0: [sdc] Write Protect is off
[ 1146.007156] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1146.007158] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1148.004507] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1148.004511] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1148.004515] sd 7:0:0:0: [sdc] Sense not available.
[ 1148.004545] sd 7:0:0:0: [sdc] Write Protect is off
[ 1148.004547] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1148.004549] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1148.004699] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1148.004700] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1148.004703] sd 7:0:0:0: [sdc] Sense not available.
[ 1148.004719] sd 7:0:0:0: [sdc] Write Protect is off
[ 1148.004721] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1148.004723] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1150.001270] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1150.001279] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1150.001287] sd 7:0:0:0: [sdc] Sense not available.
[ 1150.001354] sd 7:0:0:0: [sdc] Write Protect is off
[ 1150.001359] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1150.001363] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1150.001425] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1150.001429] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1150.001437] sd 7:0:0:0: [sdc] Sense not available.
[ 1150.001452] sd 7:0:0:0: [sdc] Write Protect is off
[ 1150.001457] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1150.001461] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1151.997916] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1151.997925] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1151.997932] sd 7:0:0:0: [sdc] Sense not available.
[ 1151.998000] sd 7:0:0:0: [sdc] Write Protect is off
[ 1151.998004] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1151.998008] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1151.998071] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1151.998076] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1151.998083] sd 7:0:0:0: [sdc] Sense not available.
[ 1151.998098] sd 7:0:0:0: [sdc] Write Protect is off
[ 1151.998103] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1151.998108] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1153.994472] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1153.994478] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1153.994481] sd 7:0:0:0: [sdc] Sense not available.
[ 1153.994513] sd 7:0:0:0: [sdc] Write Protect is off
[ 1153.994515] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1153.994517] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1153.994633] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1153.994635] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1153.994638] sd 7:0:0:0: [sdc] Sense not available.
[ 1153.994655] sd 7:0:0:0: [sdc] Write Protect is off
[ 1153.994657] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1153.994659] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1155.991127] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1155.991133] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1155.991137] sd 7:0:0:0: [sdc] Sense not available.
[ 1155.991176] sd 7:0:0:0: [sdc] Write Protect is off
[ 1155.991178] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1155.991180] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1155.991264] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1155.991266] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1155.991268] sd 7:0:0:0: [sdc] Sense not available.
[ 1155.991283] sd 7:0:0:0: [sdc] Write Protect is off
[ 1155.991284] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1155.991286] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1157.987078] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1157.987087] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1157.987094] sd 7:0:0:0: [sdc] Sense not available.
[ 1157.987110] sd 7:0:0:0: [sdc] Write Protect is off
[ 1157.987116] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1157.987120] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1156.110889] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1156.110895] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1156.110903] sd 7:0:0:0: [sdc] Sense not available.
[ 1156.110919] sd 7:0:0:0: [sdc] Write Protect is off
[ 1156.110924] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1156.110928] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1158.107300] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1158.107309] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1158.107317] sd 7:0:0:0: [sdc] Sense not available.
[ 1158.107333] sd 7:0:0:0: [sdc] Write Protect is off
[ 1158.107339] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1158.107344] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1158.107427] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1158.107431] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1158.107438] sd 7:0:0:0: [sdc] Sense not available.
[ 1158.107489] sd 7:0:0:0: [sdc] Write Protect is off
[ 1158.107494] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1158.107499] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1160.104012] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1160.104021] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1160.104028] sd 7:0:0:0: [sdc] Sense not available.
[ 1161.980453] sd 7:0:0:0: [sdc] Write Protect is off
[ 1161.980460] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1161.980465] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1160.104254] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1160.104259] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1160.104266] sd 7:0:0:0: [sdc] Sense not available.
[ 1160.104282] sd 7:0:0:0: [sdc] Write Protect is off
[ 1160.104287] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1160.104292] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1162.100537] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1162.100546] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1162.100554] sd 7:0:0:0: [sdc] Sense not available.
[ 1162.100571] sd 7:0:0:0: [sdc] Write Protect is off
[ 1162.100577] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1162.100581] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1162.100776] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1162.100781] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1162.100788] sd 7:0:0:0: [sdc] Sense not available.
[ 1162.100823] sd 7:0:0:0: [sdc] Write Protect is off
[ 1162.100828] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1162.100833] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1164.097170] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1164.097179] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1164.097186] sd 7:0:0:0: [sdc] Sense not available.
[ 1164.097290] sd 7:0:0:0: [sdc] Write Protect is off
[ 1164.097294] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1164.097298] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1164.097360] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1164.097364] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1164.097372] sd 7:0:0:0: [sdc] Sense not available.
[ 1164.097387] sd 7:0:0:0: [sdc] Write Protect is off
[ 1164.097392] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1164.097396] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1166.093815] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1166.093824] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1166.093831] sd 7:0:0:0: [sdc] Sense not available.
[ 1166.093896] sd 7:0:0:0: [sdc] Write Protect is off
[ 1166.093901] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1166.093904] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1166.093964] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1166.093968] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1166.093976] sd 7:0:0:0: [sdc] Sense not available.
[ 1166.093991] sd 7:0:0:0: [sdc] Write Protect is off
[ 1166.093996] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1166.094000] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1168.090454] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1168.090463] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1168.090470] sd 7:0:0:0: [sdc] Sense not available.
[ 1168.090486] sd 7:0:0:0: [sdc] Write Protect is off
[ 1168.090492] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1168.090496] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1169.966951] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1169.966957] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1169.966965] sd 7:0:0:0: [sdc] Sense not available.
[ 1169.966981] sd 7:0:0:0: [sdc] Write Protect is off
[ 1169.966986] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1169.966990] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1171.963455] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1171.963465] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1171.963472] sd 7:0:0:0: [sdc] Sense not available.
[ 1171.963488] sd 7:0:0:0: [sdc] Write Protect is off
[ 1171.963492] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1171.963497] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1171.963580] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1171.963584] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1171.963590] sd 7:0:0:0: [sdc] Sense not available.
[ 1170.087302] sd 7:0:0:0: [sdc] Write Protect is off
[ 1170.087308] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1170.087312] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1172.083711] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1172.083720] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1172.083727] sd 7:0:0:0: [sdc] Sense not available.
[ 1172.083794] sd 7:0:0:0: [sdc] Write Protect is off
[ 1172.083798] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1172.083802] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1172.083862] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1172.083866] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1172.083873] sd 7:0:0:0: [sdc] Sense not available.
[ 1172.083888] sd 7:0:0:0: [sdc] Write Protect is off
[ 1172.083893] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1172.083898] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1174.080399] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1174.080408] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1174.080415] sd 7:0:0:0: [sdc] Sense not available.
[ 1174.080481] sd 7:0:0:0: [sdc] Write Protect is off
[ 1174.080485] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1174.080489] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1174.080550] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1174.080554] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1174.080561] sd 7:0:0:0: [sdc] Sense not available.
[ 1174.080577] sd 7:0:0:0: [sdc] Write Protect is off
[ 1174.080582] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1174.080587] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1176.077035] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1176.077044] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1176.077052] sd 7:0:0:0: [sdc] Sense not available.
[ 1176.077067] sd 7:0:0:0: [sdc] Write Protect is off
[ 1176.077072] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1176.077076] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1177.953530] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1177.953536] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1177.953544] sd 7:0:0:0: [sdc] Sense not available.
[ 1177.953559] sd 7:0:0:0: [sdc] Write Protect is off
[ 1177.953564] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1177.953569] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1179.950038] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1179.950048] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1179.950055] sd 7:0:0:0: [sdc] Sense not available.
[ 1179.950072] sd 7:0:0:0: [sdc] Write Protect is off
[ 1179.950076] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1179.950080] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1179.950141] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1179.950146] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1179.950154] sd 7:0:0:0: [sdc] Sense not available.
[ 1179.950170] sd 7:0:0:0: [sdc] Write Protect is off
[ 1179.950175] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1179.950179] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1181.946621] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1181.946630] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1181.946637] sd 7:0:0:0: [sdc] Sense not available.
[ 1181.946653] sd 7:0:0:0: [sdc] Write Protect is off
[ 1181.946659] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1181.946663] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1181.946721] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1181.946725] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1181.946733] sd 7:0:0:0: [sdc] Sense not available.
[ 1181.946748] sd 7:0:0:0: [sdc] Write Protect is off
[ 1181.946752] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1181.946757] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1183.949931] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1183.949939] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1183.949947] sd 7:0:0:0: [sdc] Sense not available.
[ 1183.950018] sd 7:0:0:0: [sdc] Write Protect is off
[ 1183.950022] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1183.950026] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1183.950086] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1183.950090] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1183.950098] sd 7:0:0:0: [sdc] Sense not available.
[ 1183.950114] sd 7:0:0:0: [sdc] Write Protect is off
[ 1183.950118] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1183.950123] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1185.946612] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1185.946622] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1185.946629] sd 7:0:0:0: [sdc] Sense not available.
[ 1185.946701] sd 7:0:0:0: [sdc] Write Protect is off
[ 1185.946705] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1185.946709] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1185.946772] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1185.946776] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1185.946784] sd 7:0:0:0: [sdc] Sense not available.
[ 1185.946800] sd 7:0:0:0: [sdc] Write Protect is off
[ 1185.946806] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1185.946810] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1187.943209] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1187.943218] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1187.943225] sd 7:0:0:0: [sdc] Sense not available.
[ 1187.943242] sd 7:0:0:0: [sdc] Write Protect is off
[ 1187.943253] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1187.943257] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1186.067097] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1186.067103] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1186.067110] sd 7:0:0:0: [sdc] Sense not available.
[ 1186.067127] sd 7:0:0:0: [sdc] Write Protect is off
[ 1186.067132] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1186.067136] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1188.063471] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1188.063479] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1188.063487] sd 7:0:0:0: [sdc] Sense not available.
[ 1188.063544] sd 7:0:0:0: [sdc] Write Protect is off
[ 1188.063548] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1188.063552] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1188.063611] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1188.063615] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1188.063623] sd 7:0:0:0: [sdc] Sense not available.
[ 1188.063638] sd 7:0:0:0: [sdc] Write Protect is off
[ 1188.063644] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1188.063648] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1190.060108] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1190.060117] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1190.060124] sd 7:0:0:0: [sdc] Sense not available.
[ 1190.060525] sd 7:0:0:0: [sdc] Write Protect is off
[ 1190.060530] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1190.060533] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1190.060941] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1190.060946] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1190.060953] sd 7:0:0:0: [sdc] Sense not available.
[ 1190.060969] sd 7:0:0:0: [sdc] Write Protect is off
[ 1190.060974] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1190.060979] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1192.056767] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1192.056777] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1192.056784] sd 7:0:0:0: [sdc] Sense not available.
[ 1192.056800] sd 7:0:0:0: [sdc] Write Protect is off
[ 1192.056805] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1192.056810] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1193.933274] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1193.933279] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1193.933288] sd 7:0:0:0: [sdc] Sense not available.
[ 1193.933304] sd 7:0:0:0: [sdc] Write Protect is off
[ 1193.933309] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1193.933314] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1195.929747] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1195.929757] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1195.929764] sd 7:0:0:0: [sdc] Sense not available.
[ 1195.929835] sd 7:0:0:0: [sdc] Write Protect is off
[ 1195.929840] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1195.929844] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1195.929906] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1195.929910] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1195.929918] sd 7:0:0:0: [sdc] Sense not available.
[ 1195.929934] sd 7:0:0:0: [sdc] Write Protect is off
[ 1195.929938] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1195.929943] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1197.926388] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1197.926397] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1197.926404] sd 7:0:0:0: [sdc] Sense not available.
[ 1197.926475] sd 7:0:0:0: [sdc] Write Protect is off
[ 1197.926479] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1197.926483] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1197.926545] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1197.926550] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1197.926557] sd 7:0:0:0: [sdc] Sense not available.
[ 1197.926572] sd 7:0:0:0: [sdc] Write Protect is off
[ 1197.926577] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1197.926582] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1199.923130] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1199.923139] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1199.923147] sd 7:0:0:0: [sdc] Sense not available.
[ 1198.046895] sd 7:0:0:0: [sdc] Write Protect is off
[ 1198.046903] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1198.046908] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1198.047010] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1198.047014] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1198.047022] sd 7:0:0:0: [sdc] Sense not available.
[ 1198.047038] sd 7:0:0:0: [sdc] Write Protect is off
[ 1198.047044] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1198.047048] sd 7:0:0:0: [sdc] Assuming drive cache: write through
: Successful su for root by root
: + pts/1 root:root
: (pam_unix) session opened for user root by (uid=0)
: (pam_unix) session closed for user root
y4 main process (3053) killed by TERM signal
y5 main process (3054) killed by TERM signal
y2 main process (3060) killed by TERM signal
y3 main process (3061) killed by TERM signal
y1 main process (3062) killed by TERM signal
y6 main process (3063) killed by TERM signal
root-4337): Received signal 15, shutting down cleanly
root-4337): Exiting
3986]: (pam_unix) session closed for user root
[ 1200.046508] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1200.046513] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1200.046517] sd 7:0:0:0: [sdc] Sense not available.
[ 1200.046525] sd 7:0:0:0: [sdc] Write Protect is off
[ 1200.046527] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1200.046530] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1201.922929] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1201.922932] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1201.922935] sd 7:0:0:0: [sdc] Sense not available.
[ 1201.922943] sd 7:0:0:0: [sdc] Write Protect is off
[ 1201.922946] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1201.922948] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1203.920304] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1203.920423] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1203.920648] sd 7:0:0:0: [sdc] Sense not available.
[ 1203.923141] sd 7:0:0:0: [sdc] Write Protect is off
[ 1203.923251] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1203.923364] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1203.925791] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1203.925901] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1203.926127] sd 7:0:0:0: [sdc] Sense not available.
[ 1203.926989] sd 7:0:0:0: [sdc] Write Protect is off
[ 1203.927103] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1203.927215] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1205.916257] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1205.916385] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1205.916622] sd 7:0:0:0: [sdc] Sense not available.
[ 1204.040589] sd 7:0:0:0: [sdc] Write Protect is off
[ 1204.040713] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1204.040832] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1204.041249] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1204.041370] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1204.041609] sd 7:0:0:0: [sdc] Sense not available.
[ 1204.041835] sd 7:0:0:0: [sdc] Write Protect is off
[ 1204.041956] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1204.042076] sd 7:0:0:0: [sdc] Assuming drive cache: write through
sd[3522]: Closing acpid connection 
sd[3522]: Closing control socket 
sd[3522]: ATI External Events Daemon shutting down 
[ 1206.036416] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1206.036534] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1206.036775] sd 7:0:0:0: [sdc] Sense not available.
[ 1206.036898] sd 7:0:0:0: [sdc] Write Protect is off
[ 1206.037125] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1206.037250] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1206.038500] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1206.038744] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1206.039008] sd 7:0:0:0: [sdc] Sense not available.
[ 1206.040303] sd 7:0:0:0: [sdc] Write Protect is off
[ 1206.040534] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1206.040647] sd 7:0:0:0: [sdc] Assuming drive cache: write through
d[3745]: Caught signal 15, un-registering and exiting.
