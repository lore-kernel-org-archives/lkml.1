Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbZEYLIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbZEYLIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbZEYLIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:08:09 -0400
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:45310 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbZEYLII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:08:08 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4A1A7BE2.3080908@cam.ac.uk>
Date: Mon, 25 May 2009 11:07:14 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Kim Kyuwon <q1.kim@samsung.com>
CC: felipe.balbi@nokia.com, Kim Kyuwon <chammoru@gmail.com>,
       Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Jean Delvare <khali@linux-fr.org>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       "Gross, Mark" <mark.gross@intel.com>,
       jketreno <jketreno@linux.intel.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>
Subject: Re: [RFC] Add Input IOCTL for accelerometer devices
References: <20090515131636.GE4443@nokia.com> <5d5443650905151106v2fe7ad1ci6c966463a991e732@mail.gmail.com> <45cc95260905151230j5485995dpbbd882dc91b25339@mail.gmail.com> <20090515200235.GA11829@nokia.com> <4d34a0a70905180045u6619773dt1563fe38b13d46fb@mail.gmail.com> <20090518091236.GH4443@nokia.com> <4A11344B.3000405@cam.ac.uk> <4A125265.6040509@samsung.com> <4A153E3E.8090509@cam.ac.uk> <4A166083.8080704@samsung.com> <4A16AA1E.9010407@cam.ac.uk> <4A1A538F.2030003@samsung.com>
In-Reply-To: <4A1A538F.2030003@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyuwon,

I've cropped this conversation down a fair bit in an attempt to make
it more focused.

...
>>> Our objective is merging code upstream. We have lots of kernel drivers
>>> and kernel features which we are using everyday However, I know these
>>> are can't be merged kernel.
>> This is not the place to get into that sort of argument so I'll keep my
>> reply to this short.
>>
>> Why not?  If you have something that is useful, then why not submit it?
> 
> I didn't say we have something useful.
Fair enough, though that does beg the question of why you are using them!
 
>> This is particularly true in cases like this were the useful element
>> doesn't change anything already in kernel and hence if people don't want
>> it then it won't effect them.
> 
> If we submit ugly and messy drivers and kernel features, none would be
> happy.
Well if you don't have time to clean them up, that's one of the major
reasons for the existence of the staging tree.  Obviously it's a hotly
debated topic of whether that tree is a good idea, but I'd rather there
was a dubious driver readily available to other developers than none
at all.
> 

>> Yes.  That may be the way to go down the line.
>>>>  Why don't we to be simple. Please let me understand in easy
>>>>> words.
>>>>>
>>>>> Let me ask a few question in conclusion.
>>>> Firstly thanks for sending this driver, its always enlightening to see
>>>> how people have handled such a device.  Out of interest, have you
>>>> posted this to the input list?  I'd be interested to see what their
>>>> comments are.
>>> I can't add this driver to input list, because this kxsd9 driver is for
>>> accelerometer.
>> Why does this prevent you posting it there?  It is using the input
>> framework
>> so if it was going anywhere in the kernel it would require a review
>> and ACK
>> from the relevant people on that list in much the same way as it
>> should also
>> be posted to the spi / i2c list as appropriate for review. 
> 
> OK,
> 
> To. Dmitry,
> Can I merge my kxsd9 *accelerometer* driver to input system?
> 
... left the next bit in as I think it might be useful for review
purposes on the input list.

>>>>
>>>> As a more general comment, I'd also argue that the reading you
>>>> take on interrupt is irrelevant. The event was the threshold pass, not
>>>> the
>>>> value of the reading. It should be up to userspace to decide if it
>>>> cares what
>>>> the reading is and if it does, it has a polling mode with which to
>>>> read it.
>>>> As I read the data sheet, the device isn't storing the accelerations at
>>>> interrupt, so the value you are reading is not relevant to the event
>>>> at all, but
>>>> typically will be another reading.
>>>>> it seems like your coding style doesn't look like Linux coding style
>>>>> that I'm familiar with.
>>>> As far as I know the code absolutely conforms to every coding style
>>>> convention of the kernel.  The version in the 'mess' branch has a few
>>>> comment
>>>> clean ups as a result of checking the kernel doc comments.  If you have
>>>> specific examples please send them on and I'll be happy to clean
>>>> them up.
>>> For instance, please
>>> drivers/industrialio/ -exec ./scripts/checkpatch.pl --file {} \;
>> Ok, I'm seeing a couple of minor formatting errors which I typically only
>> clean up properly when I am posting a set to lkml.  Those sets are always
>> verified with checkpatch. What you are looking at is my development tree
>> not one that I've carefully checked before posting.  Some of the errors
>> are entirely deliberate.  I frequently use c99 comments in order to
>> indicate that I need to clarify them before formally posting patches for
>> reviews (precisely because checkpatch ensures I don't forget to do it!)
> 
> Your development tree is opened to other developers and other developers
> would evaluate you though the code in your development tree. You can use
> enough c99 comments and other checkpatch errors just in your local repo.

In general I'd agree with that observation, but in common with patches in
numerous other 'development' trees including for example the staging there
are elements of my trees that are not 'clean'.   Also note that the 'mess'
branch was a direct dump of my local repository as there were a couple of
bug fixes in there that I haven't had time to clean up properly yet.
 
>> If that's what you mean by 'your coding style doesn't look like Linux
>> coding
>> style' then you are massively exaggerating.
> 
> I said "For instance".
Fair enough. I'd appreciate any comments when I do a formal posting of
the patch series.
> 
>> If these sort of things really cause you trouble then look at the formal
>> submissions to lkml. If I hadn't wanted to make the latest and most
>> stable
>> version of our internal code available as it was relevant to this
>> discussion
>> then I would have waited until I had time to clean up trivial formating
>> errors.
>>
>>>>> I just hope we can add some accelerometer feature into mainline kernel
>>>>> as soon as possible ;)
>>>> I agree.  The stop gap solution (which a number drivers have taken) is
>>>> to put
>>>> them in drivers/misc on the basis that when we do have an agreed
>>>> system we can
>>>> then move them over at a later date.  I have already offered to do the
>>>> conversions for a number of such drivers when iio gets merged.
>>>>
>>>> Jonathan
>>>>
>>> Finally,
>>> Are you OK if someone trys making another framework for input(?)-sensor
>>> or accelerometer.
>> Of course I have no objections.
> 
> Thanks,
You are welcome. I'd also be happy to assist with reviewing etc of devices
I actually have.  If the input guys are happy with your driver in general,
I'd particularly like you to address my question about the nature of the
data in the interrupt driven event as mentioned above.
> 
>> If people want a unified framework useful for all the common applications
>> of these devices then it will need to contain equivalents of what IIO
>> does, if
>> as previously discussed it makes more sense to have separate drivers then
>> go ahead.  I'd advocate posting your current driver to the input list and
>> inquiring what their opinions are on the matter.
>>
>> My personal opinion on this is:
>>
>> 1) The way accelerometers are currently used for input is very simple,
>> much
>> more complex systems using information derived from multiple sensors will
>> become common in the future (similar to the new wii remotes) or the stuff
>> done by companies like Xsens.  This sort of stuff will require some
>> elements
>> similar to IIO (principally synchronized triggered capture from multiple
>> sensors).
>>
>> 2) For the level of device support you are talking about, there is no
>> direct
>> reason it shouldn't go into the main input system. There is no need
>> for a new
>> subsystem. Over to Dmitry to point out what I'm missing.  For example,
>> the lis3lv02
>> driver (in hwmon) does exactly this.  That driver was accepted
>> by the input guys. Perhaps a drivers/input/accelerometer directory
>> makes sense
>> to group the drivers.
> 
> I really respect your enthusiasm.
Thanks. This conversation has definitely emphasized a few issues we
left 'for later discussion' in the original threads.

Jonathan
