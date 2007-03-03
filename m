Return-Path: <linux-kernel-owner+w=401wt.eu-S932396AbXCCUaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbXCCUaS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 15:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932395AbXCCUaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 15:30:18 -0500
Received: from smtp-out4.blueyonder.co.uk ([195.188.213.7]:49800 "EHLO
	smtp-out4.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932451AbXCCUaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 15:30:14 -0500
Message-ID: <45E9DACD.4080308@blueyonder.co.uk>
Date: Sat, 03 Mar 2007 20:30:05 +0000
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: Avi Kivity <avi@argo.co.il>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
References: <45E939E1.8050501@argo.co.il>
In-Reply-To: <45E939E1.8050501@argo.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>
> Sid Boyce wrote:
> > Avi Kivity wrote:
> >> Sid Boyce wrote:
> >>>> > That's very much appreciated. The point is that all vanilla
> >>>> kernels up
> >>>> > to 2.6.20+ have not had the problems now seen on 2.6.20-rc1 and
> >>>> > 2.6.20-rc2 and like other problems reported, sic framebuffer, 
> etc.,
> >>>> > there is a distinct likelihood that it's related to those kernels
> >>>> and
> >>>> > worth reporting here where it will also be seen by the openSUSE
> >>>> kernel
> >>>> > developers.
> >>>>
> >>>> Try running an strace on kwin and reporting the result.
> >>>>
> >>>>
> >>> Modified /opt/kde3/bin/startkde as below, but got no output, not
> >>> even an empty file.
> >>> strace -s 256 -f kwin --lock -o /home/lancelot/KWIN.out &
> >>
> >> Perhaps that line is never executed.
> >>
> >> Try running kwin from your konsole after it dies, with the strace of
> >> course. Oh, and put the '-o ...' before the kwin command, not after.
> >>
> >>
> >
> > Oops!, above text should read the same as the subject line,  problems
> > seen on 2.6.21-rc1 and 2.6.21-rc2.
> > The strace is huge 2737627 2007-03-02 03:28 KWIN.out.  Further digging
> > shows kwin, kicker and klauncher and perhaps other kdeinit stuff also
> > die - no desktop icons after those 3 are started from the commandline.
> > Moving kdesktop_lock out of /opt/kde3/bin, everything comes back after
> > the video is blanked -- no password required.
> > I shall run like that (2.6.21-rc2-git1 currently) and wait for
> > openSUSE to upgrade to 2.6.21. I can send the straces of kicker and
> > kwin on if you think it's still worth it.
>
> Post the last few lines of the strace.
>
>
> -- 
> Do not meddle in the internals of kernels, for they are subtle and 
> quick to panic.
>
 From kwin, the exit was caused by me doing CTRL-ALT-BKSPC after the 
kdeinit stuff had exited.
=============================================================
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  gettimeofday({1172806052, 373523}, NULL) = 0
7670  gettimeofday({1172806052, 373583}, NULL) = 0
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, [{"\22\0\17\0q\0@\0#\0\0\0#\0\0\0 
\0\0\0\t\0\0\0C\0\0\0\1\0\0\0\1\0\0\0\244\334\4\10\364\237}\267\230\r\304\277\220\200`\267\244\334\4\10\2\0
@\0\22\0\7\0q\0@\0\365\0\0\0\6\0\0\0 
\0\0\0\1\0\0\0\364\346H\0\10\0\2\0q\0@\0\10\0\2\0\33\0@\0\10\0\2\0\34\0@\0\10\0\2\0\7\0\300\0\22\0\7\0\v\0\0\1\0\1\0\0\4
\0\0\0 
\0\0\0\1\0\0\0\177\1\0\0\10\0\2\0t\5@\0\10\0\2\0u\5@\0\10\0\2\0\v\0\0\1\22\0\7\0009\1\0\0k\1\0\0!\0\0\0 
\0\0\0\1\0\0\0\0\0\0\0\35\0\3\0u\5@\0\0\200\0\
0\34\0\6\0u\5@\0\4\0\0\1\0\0\0\0\0\0\0\0\0\0\0\200"..., 320}], 1) = 320
7670  read(3, 
"\34\227\226@9\1\0\0\222\1\0\0\217\313J\0\0\1\0\0\2\0\0\0\0\0\0\0009\1\0\0\34\275\227@q\0@\0#\0\0\0\217\313J\0\0\0\0\0\2\0\0\0\0\0\0\0q\0@\0\34
\275\230@q\0@\0\365\0\0\0\217\313J\0\0\0\0\0\2\0\0\0\0\0\0\0q\0@\0\23Z\231@q\0@\0q\0@\0\0\275j\10\370Y\227\277\214\33\t\10\200\275j\10q\0@\0\23Z\232@\33\0@\0
\33\0@\0\0\275j\10\370Y\227\277\214\33\t\10\200\275j\10\33\0@\0\23Z\232@9\1\0\0\33\0@\0\0\275j\10\370Y\227\277\214\33\t\10\200\275j\10\33\0@\0\f\6\232@q\0@\0
\27\0\0\0\326\5\27\0\3\0\34\10\0\0\0\0\250X\227"..., 4096) = 1280
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 
"\34N\246@\7\0\300\0E\1\0\0\222\313J\0\0\1\0\0\2\0\0\0\0\0\0\0\7\0\300\0", 
4096) = 32
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, [{"\24\0\6\0\357\0\340\0u\0\0\0u\0\0\0\0\0\0\0\1\0\0\0", 
24}], 1) = 24
7670  select(4, [3], [], NULL, NULL)    = 1 (in [3])
7670  read(3, "\1 
\247@\1\0\0\0u\0\0\0\4\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\1\0\0\0", 
4096) = 36
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, 
[{"\24\0\6\0\357\0\340\0\0\1\0\0\4\0\0\0\0\0\0\0\0\10\0\0", 24}], 1) = 24
7670  select(4, [3], [], NULL, NULL)    = 1 (in [3])
7670  read(3, "\1 
\250@\2\0\0\0\4\0\0\0\0\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\202\1\0\0|\1\0\0", 
4096) = 40
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, [{"\24\0\6\0\7\0\300\0u\0\0\0u\0\0\0\0\0\0\0\1\0\0\0", 
24}], 1) = 24
7670  select(4, [3], [], NULL, NULL)    = 1 (in [3])
7670  read(3, "\1 
\251@\1\0\0\0u\0\0\0\4\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\1\0\0\0", 
4096) = 36
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, 
[{"\24\0\6\0\7\0\300\0\0\1\0\0\4\0\0\0\0\0\0\0\0\10\0\0", 24}], 1) = 24
7670  select(4, [3], [], NULL, NULL)    = 1 (in [3])
7670  read(3, "\1 
\252@\2\0\0\0\4\0\0\0\0\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\r\1\0\0%\1\0\0", 
4096) = 40
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, 
[{"\24\0\6\0\7\0\300\0E\1\0\0001\1\0\0\0\0\0\0\240\206\1\0", 24}], 1) = 24
7670  select(4, [3], [], NULL, NULL)    = 1 (in [3])
7670  read(3, 
"\1\10\253@\1\0\0\0001\1\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0000\1\0\0", 
4096) = 36
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, 
[{";\3\v\0*\0@\0\0\0\0\0\27\0\0\0\326\5\27\0\4\6\0\0\1\0\27\0\34\6\0\0\r\0\27\0\0\0\27\0@\6\231\4\234\6\v\0>\1@\0\0\0\0\0\27\0\0\0\326\5\27\0
\4\6\0\0\1\0\27\0\34\6\0\0\r\0\27\0\0\0\27\0@\6\231\4;\3\v\0002\0@\0\0\0\0\0\27\0\0\0\326\5\27\0\4\6\0\0\1\0\27\0\34\6\0\0\r\0\27\0\0\0\27\0@\6\231\0048\3\7\
0002\0@\0\0005\0\0\0\0\0\0n\0@\0\0\0\0\0\0\0\0\0008\3\5\0002\0@\0\0!\0\0\1\0\0\0\374\377\377\377F\0\5\0q\0@\0002\0@\0\0\0\0\0@\6\30\0008\3\6\0002\0@\0\0%\0\0
\0\0\0\0r\5@\0\0\0\0\0008\3\6\0002\0@\0\0001\0\0\1"..., 284}], 1) = 284
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, 
[{"F\5\5\0v\0@\0P\0@\0\0\0\0\0\27\0\27\0008\5\4\0*\0@\0\0\0\10\0\0\0\0\0005\30\4\0\0\10@\0009\1\0\0\27\0\27\0\234\4\5\0\1\10@\0\0\10@\0\344\0
\0\0\0\0\0\0008\4\4\0*\0@\0\0\4\0\0n\0@\0008\4\5\0*\0@\0\0!\0\0\1\0\0\0\374\377\377\377F\377\5\0\0\10@\0*\0@\0\0\0\0\0\27\0\27\0B\4\5\0\0\10@\0y\0@\0\0\0\2\0
\0\0\24\0B\4\5\0\0\10@\0y\0@\0\26\0\2\0\26\0\24\0B\4\5\0\0\10@\0y\0@\0\2\0\0\0\24\0\0\0B\4\5\0\0\10@\0y\0@\0\2\0\26\0\24\0\26\0@\0\4\0\0\10@\0y\0@\0\1\0\1\0@
\0\4\0\0\10@\0y\0@\0\1\0\25\0@\0\4\0\0\10@\0y\0@\0"..., 956}], 1) = 956
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, 
[{"F\7\5\0v\0@\0P\0@\0\0\0\0\0\27\0\27\0005\30\4\0\2\10@\0009\1\0\0\27\0\27\0\234\4\5\0\3\10@\0\2\10@\0\344\0\0\0\0\0\0\0008\4\4\0*\0@\0\0\4\
0\0n\0@\0008\4\5\0*\0@\0\0!\0\0\1\0\0\0\374\377\377\377F\0\5\0\2\10@\0*\0@\0\0\0\0\0\27\0\27\0B\4\5\0\2\10@\0y\0@\0\0\0\2\0\0\0\24\0B\4\5\0\2\10@\0y\0@\0\26\
0\2\0\26\0\24\0B\4\5\0\2\10@\0y\0@\0\2\0\0\0\24\0\0\0B\4\5\0\2\10@\0y\0@\0\2\0\26\0\24\0\26\0@\0\4\0\2\10@\0y\0@\0\1\0\1\0@\0\4\0\2\10@\0y\0@\0\1\0\25\0@\0\4
\0\2\10@\0y\0@\0\25\0\1\0@\0\4\0\2\10@\0y\0@\0\25\0"..., 940}], 1) = 940
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, 
[{"F\7\5\0v\0@\0P\0@\0\0\0\0\0\27\0\27\0005\30\4\0\4\10@\0009\1\0\0\27\0\27\0\234\4\5\0\5\10@\0\4\10@\0\344\0\0\0\0\0\0\0008\4\4\0*\0@\0\0\4\
0\0n\0@\0008\4\5\0*\0@\0\0!\0\0\1\0\0\0\374\377\377\377F\0\5\0\4\10@\0*\0@\0\0\0\0\0\27\0\27\0B\4\5\0\4\10@\0y\0@\0\0\0\2\0\0\0\24\0B\4\5\0\4\10@\0y\0@\0\26\
0\2\0\26\0\24\0B\4\5\0\4\10@\0y\0@\0\2\0\0\0\24\0\0\0B\4\5\0\4\10@\0y\0@\0\2\0\26\0\24\0\26\0@\0\4\0\4\10@\0y\0@\0\1\0\1\0@\0\4\0\4\10@\0y\0@\0\1\0\25\0@\0\4
\0\4\10@\0y\0@\0\25\0\1\0@\0\4\0\4\10@\0y\0@\0\25\0"..., 940}], 1) = 940
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, 
[{"F\7\5\0v\0@\0P\0@\0\0\0\0\0\27\0\27\0005\30\4\0\6\10@\0009\1\0\0\27\0\27\0\234\4\5\0\7\10@\0\6\10@\0\344\0\0\0\0\0\0\0008\4\4\0*\0@\0\0\4\
0\0n\0@\0008\4\5\0*\0@\0\0!\0\0\1\0\0\0\374\377\377\377F\0\5\0\6\10@\0*\0@\0\0\0\0\0\27\0\27\0I\2\5\0#\0@\0\0\0\0\0\20\0\20\0\377\377\377\377", 
132}], 1) = 1
32
7670  select(4, [3], [], NULL, NULL)    = 1 (in [3])
7670  read(3, 
"\1\0305A\0\1\0\0\0\0\0\0\320\223U\10\30Z\227\277LP\24\10\340\33\36\10\360Y\227\277\222\222\222W\314\314\314\313\315\315\315\316\315\315\315\31
6\315\315\315\316\315\315\315\316\315\315\315\316\315\315\315\316\315\315\315\316\315\315\315\316\314\314\314\316\314\314\314\316\313\313\313\316\313\313\313
\317\277\277\277\275QQQ%\316\316\316\360\356\356\356\377\321\321\321\377\342\342\342\377\342\342\342\377\342\342\342\377\342\342\342\377\342\342\342\377\342\
342\342\377\342\342\342\377\342\342\342\377\342"..., 4096) = 1056
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, [{"I\2\5\0&\0@\0\0\0\0\0\20\0\20\0\377\377\377\377", 
20}], 1) = 20
7670  select(4, [3], [], NULL, NULL)    = 1 (in [3])
7670  read(3, 
"\1\0106A@\0\0\0\0\0\0\0\364\337\34\10\30Z\227\277LP\24\10\340\33\36\10\360Y\227\277W\313\316\316\316\316\316\316\316\316\316\316\316\317\275%\
360\377\377\377\377\377\377\377\377\377\377\377\377\377\377\240\370\377\377\377\377\377\377\377\377\377\377\377\377\377\377\253\370\377\377\377\377\377\377\3
77\377\377\377\377\377\377\377\253\370\377\377\377\377\377\377\377\377\377\377\377\377\377\377\253\370\377\377\377\377\377\377\377\377\377\377\377\377\377\37
7\253\370\377\377\377\377\377\377\377\377\377\377"..., 4096) = 288
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, 
[{"5\30\4\0\10\10@\0009\1\0\0\20\0\20\0>\30\7\0#\0@\0\10\10@\0P\0@\0\0\0\0\0\0\0\0\0\20\0\20\0005\1\4\0\t\10@\0009\1\0\0\20\0\20\0008\1\4\0\3
05\0@\0\0\1\0\0\0\0\0\0F\0\5\0\t\10@\0\305\0@\0\0\0\0\0\20\0\20\0008\1\5\0\305\0@\0\0\t\0\0\3\0\0\0$\0@\0F\1\5\0\t\10@\0\305\0@\0\0\0\0\0\20\0\20\0005\10\4\0
\n\10@\0009\1\0\0\20\0\20\0007\10\4\0\v\10@\0\n\10@\0\0\0\0\0008\10\5\0\v\10@\0\f\0\0\0\377\0\0\0\377\0\0\0F\10\5\0\n\10@\0\v\10@\0\0\0\0\0\20\0\20\0>\10\7\0
&\0@\0\n\10@\0\v\10@\0\0\0\0\0\0\0\0\0\20\0\20\0<\10"..., 1972}], 1) = 1972
7670  select(4, [3], [], NULL, NULL)    = 1 (in [3])
7670  read(3, "\16YBA\n\10@\0\0\0>\0\250\220U\10 
|\35\10\2\0\0\300\1\0\0\0\340`\213\10\1\1\\A\0\0\0\0009\1\0\0\0\0\0\0\216\4\307\1\216\4\307\1\20\0_\10(Z\227
\277", 4096) = 64
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, 
[{"*\1\3\0\7\0\300\0\220\313J\0\31\0\v\0\7\0\300\0\0\0\0\0! 
\0\0\7\0\300\0/\1\0\0#\1\0\0\220\313J\0\0\0\0\0\0\0\0\0\0\0\0\0", 56}], 
1) = 56
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, [{"\24\0\6\0\v\0\0\1\0\1\0\0\4\0\0\0\0\0\0\0\0\10\0\0", 
24}], 1) = 24
7670  select(4, [3], [], NULL, NULL)    = 1 (in [3])
7670  read(3, "\1 
_A\1\0\0\0\4\0\0\0\0\0\0\0\1\0\0\0\271g\t\10`\312$\10\210\260\215\10\177\1\0\0", 
4096) = 36
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  gettimeofday({1172806052, 392707}, NULL) = 0
7670  ioctl(5, FIONREAD, [0])           = 0
7670  write(6, "\0", 1)                 = 1
7670  ioctl(5, FIONREAD, [1])           = 0
7670  ioctl(5, FIONREAD, [1])           = 0
7670  ioctl(5, FIONREAD, [1])           = 0
7670  ioctl(5, FIONREAD, [1])           = 0
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, [{"\22\0\7\0009\1\0\0k\1\0\0!\0\0\0 
\0\0\0\1\0\0\0\7\0\300\0\23\0\3\0\33\0@\0[\1\0\0\23\0\3\0\7\0\300\0[\1\0\0\22\0\7\0\33\0@\0\\\1\0\0\6\0\0
\0 
\0\0\0\1\0\0\0\310\0\0\0\35\0\3\0\34\0@\0\0\0\0\0\35\0\3\0\34\0@\0\2\0\0\0\35\0\3\0\34\0@\0\20\0\0\0\35\0\3\0\34\0@\0\22\0\0\0\35\0\3\0\34\0@\0\0\0\0\0\35
\0\3\0\34\0@\0\2\0\0\0\35\0\3\0\34\0@\0\20\0\0\0\35\0\3\0\34\0@\0\22\0\0\0\35\0\3\0\34\0@\0\1\0\0\0\35\0\3\0\34\0@\0\3\0\0\0\35\0\3\0\34\0@\0\21\0\0\0\35\0\3
\0\34\0@\0\23\0\0\0\35\0\3\0\34\0@\0\1\0\0\0\35\0\3"..., 3588}], 1) = 3588
7670  select(4, [3], [], NULL, NULL)    = 1 (in [3])
7670  read(3, 
"\34\275`A9\1\0\0k\1\0\0\243\313J\0\0\1\0\0\2\0\0\0\0\0\0\0009\1\0\0\34\275cA\33\0@\0\\\1\0\0\243\313J\0\0\1\0\0\2\0\0\0\0\0\0\0\33\0@\0\1\30\t
B\0\1\0\0\0\0\0\0\20\220U\10\30Z\227\277LP\24\10\340\33\36\10\360Y\227\277\222\222\222W\314\314\314\313\315\315\315\316\315\315\315\316\315\315\315\316\315\3
15\315\316\315\315\315\316\315\315\315\316\315\315\315\316\315\315\315\316\314\314\314\316\314\314\314\316\313\313\313\316\313\313\313\317\277\277\277\275QQQ
%\316\316\316\360\356\356\356\377\321\321\321\377"..., 4096) = 1120
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, [{"I\2\5\0&\0@\0\0\0\0\0\20\0\20\0\377\377\377\377", 
20}], 1) = 20
7670  select(4, [3], [], NULL, NULL)    = 1 (in [3])
7670  read(3, 
"\1\10\nB@\0\0\0\0\0\0\0\364\337\34\10\30Z\227\277LP\24\10\340\33\36\10\360Y\227\277W\313\316\316\316\316\316\316\316\316\316\316\316\317\275%\
360\377\377\377\377\377\377\377\377\377\377\377\377\377\377\240\370\377\377\377\377\377\377\377\377\377\377\377\377\377\377\253\370\377\377\377\377\377\377\3
77\377\377\377\377\377\377\377\253\370\377\377\377\377\377\377\377\377\377\377\377\377\377\377\253\370\377\377\377\377\377\377\377\377\377\377\377\377\377\37
7\253\370\377\377\377\377\377\377\377\377\377\377"..., 4096) = 288
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, 
[{"5\30\4\0\32\10@\0009\1\0\0\20\0\20\0>\30\7\0#\0@\0\32\10@\0P\0@\0\0\0\0\0\0\0\0\0\20\0\20\0005\1\4\0\33\10@\0009\1\0\0\20\0\20\0008\1\4\0\
305\0@\0\0\1\0\0\0\0\0\0F\0\5\0\33\10@\0\305\0@\0\0\0\0\0\20\0\20\0008\1\5\0\305\0@\0\0\t\0\0\3\0\0\0$\0@\0F\1\5\0\33\10@\0\305\0@\0\0\0\0\0\20\0\20\0005\10\
4\0\34\10@\0009\1\0\0\20\0\20\0007\10\4\0\35\10@\0\34\10@\0\0\0\0\0008\10\5\0\35\10@\0\f\0\0\0\377\0\0\0\377\0\0\0F\10\5\0\34\10@\0\35\10@\0\0\0\0\0\20\0\20\
0>\10\7\0&\0@\0\34\10@\0\35\10@\0\0\0\0\0\0\0\0\0\20"..., 2192}], 1) = 2192
7670  read(3, "\16Y\26B\34\10@\0\0\0>\0\220\307_\10 
|\35\10\2\0\0\300\1\0\0\0\340`\213\10", 4096) = 32
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  gettimeofday({1172806052, 399402}, NULL) = 0
7670  select(11, [3 4 5 7 9 10], [], [], {0, 0}) = 1 (in [5], left {0, 0})
7670  read(5, "\0", 1)                  = 1
7670  gettimeofday({1172806052, 399533}, NULL) = 0
7670  gettimeofday({1172806052, 399609}, NULL) = 0
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  gettimeofday({1172806052, 399676}, NULL) = 0
7670  select(11, [3 4 5 7 9 10], [], [], {0, 43031}) = 1 (in [3], left 
{0, 33000})
7670  gettimeofday({1172806052, 410534}, NULL) = 0
7670  read(3, 
"\34\22:B\357\0\340\0E\1\0\0\264\313J\0\0\1\0\0\2\0\0\0\0\0\0\0\357\0\340\0", 
4096) = 32
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, 
[{"\24\0\6\0\357\0\340\0E\1\0\0001\1\0\0\0\0\0\0\240\206\1\0", 24}], 1) = 24
7670  select(4, [3], [], NULL, NULL)    = 1 (in [3])
7670  read(3, 
"\1\10;B\1\0\0\0001\1\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0000\1\0\0", 
4096) = 36
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  gettimeofday({1172806052, 411213}, NULL) = 0
7670  select(11, [3 4 5 7 9 10], [], [], {0, 31494}) = 0 (Timeout)
7670  gettimeofday({1172806052, 444173}, NULL) = 0
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(11, [3 4 5 7 9 10], [], [], NULL) = 1 (in [3])
7670  read(3, 
"\34\22;B\7\0\300\0v\1\0\0\200\314J\0\0\1\0\0\2\0\0\0\0\0\0\0\7\0\300\0", 
4096) = 32
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, [{"\24\0\6\0\7\0\300\0v\1\0\0\6\0\0\0\0\0\0\0\4\0\0\0", 
24}], 1) = 24
7670  select(4, [3], [], NULL, NULL)    = 1 (in [3])
7670  read(3, "\1 
<B\4\0\0\0\6\0\0\0\0\0\0\0\4\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0000\2\0\0\300\377\377\377\310\0\0\0\25\0\0\0", 
4096) = 48
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(11, [3 4 5 7 9 10], [], [], NULL) = 1 (in [3])
7670  read(3, 
"\34N<B\7\0\300\0\365\0\0\0\235|K\0\0\0\0\0\2\0\0\0\0\0\0\0\7\0\300\0", 
4096) = 32
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, 
[{"\24\0\6\0\7\0\300\0\365\0\0\0\6\0\0\0\0\0\0\0\1\0\0\0", 24}], 1) = 24
7670  select(4, [3], [], NULL, NULL)    = 1 (in [3])
7670  read(3, "\1 
=B\1\0\0\0\6\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\234|K\0", 
4096) = 36
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(11, [3 4 5 7 9 10], [], [], NULL) = 1 (in [3])
7670  read(3, 
"\34N=B\7\0\300\0\365\0\0\0\327|K\0\0\0\0\0\2\0\0\0\0\0\0\0\7\0\300\0", 
4096) = 32
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(4, [3], [3], NULL, NULL)   = 1 (out [3])
7670  writev(3, 
[{"\24\0\6\0\7\0\300\0\365\0\0\0\6\0\0\0\0\0\0\0\1\0\0\0", 24}], 1) = 24
7670  select(4, [3], [], NULL, NULL)    = 1 (in [3])
7670  read(3, "\1 
 >B\1\0\0\0\6\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\326|K\0", 
4096) = 36
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  read(3, 0x8056308, 4096)          = -1 EAGAIN (Resource 
temporarily unavailable)
7670  select(11, [3 4 5 7 9 10], [], [], NULL) = 1 (in [3])
7670  read(3, "", 4096)                 = 0
7670  write(2, "kwin: Fatal IO error: client killed\n", 36) = 36
7670  munmap(0xb6a38000, 14077)         = 0
7670  munmap(0xb6a3c000, 172966)        = 0
7670  munmap(0xb6997000, 135746)        = 0
7670  munmap(0xb6990000, 25872)         = 0
7670  munmap(0xb7f3d000, 416)           = 0
7670  munmap(0xb7f3b000, 7933)          = 0
7670  munmap(0xb698f000, 410)           = 0
7670  munmap(0xb698e000, 1450)          = 0
7670  munmap(0xb698c000, 5379)          = 0

The strace from kicker started from the command line.
=============================
KMenuBase::setProperty( "frameShadow", value ) failed: property invalid, 
read-only or does not exist
KMenuBase::setProperty( "frameShape", value ) failed: property invalid, 
read-only or does not exist
lancelot@barrabas:~> QObject::connect: No such signal 
Kicker::settingsChanged(SettingsCategory)
QObject::connect:  (sender name:   'kicker')
QObject::connect:  (receiver name: 'animtt')
X Error: BadWindow (invalid Window parameter) 3
  Major opcode:  18
  Minor opcode:  0
  Resource id:  0x22000a3
X Error: BadWindow (invalid Window parameter) 3
  Major opcode:  19
  Minor opcode:  0
  Resource id:  0x22000a3
X Error: BadWindow (invalid Window parameter) 3
  Major opcode:  18
  Minor opcode:  0
  Resource id:  0x2800007
X Error: BadWindow (invalid Window parameter) 3
  Major opcode:  19
  Minor opcode:  0
  Resource id:  0x2800007
X Error: BadWindow (invalid Window parameter) 3
  Major opcode:  18
  Minor opcode:  0
  Resource id:  0x2a00161
X Error: BadWindow (invalid Window parameter) 3
  Major opcode:  19
  Minor opcode:  0
  Resource id:  0x2a00161
X Error: BadWindow (invalid Window parameter) 3
  Major opcode:  18
  Minor opcode:  0
  Resource id:  0x2c00007
X Error: BadWindow (invalid Window parameter) 3
  Major opcode:  19
  Minor opcode:  0
  Resource id:  0x2c00007
X Error: BadWindow (invalid Window parameter) 3
  Major opcode:  18
  Minor opcode:  0
  Resource id:  0x3000007
X Error: BadWindow (invalid Window parameter) 3
  Major opcode:  19
  Minor opcode:  0
  Resource id:  0x3000007

lancelot@barrabas:~> WARNING: DCOPReply<>: cast to 'QString' error
WARNING: DCOPReply<>: cast to 'QString' error
WARNING: DCOPReply<>: cast to 'QString' error
X Error: BadWindow (invalid Window parameter) 3
  Major opcode:  20
  Minor opcode:  0
  Resource id:  0x0
X Error: BadWindow (invalid Window parameter) 3
  Major opcode:  20
  Minor opcode:  0
  Resource id:  0x0
WARNING: DCOPReply<>: cast to 'QString' error
WARNING: DCOPReply<>: cast to 'QString' error
WARNING: DCOPReply<>: cast to 'QString' error
WARNING: DCOPReply<>: cast to 'QString' error
WARNING: DCOPReply<>: cast to 'QString' error
WARNING: DCOPReply<>: cast to 'QString' error
X Error: BadWindow (invalid Window parameter) 3
  Major opcode:  20
  Minor opcode:  0
  Resource id:  0x0
WARNING: DCOPReply<>: cast to 'QString' error
WARNING: DCOPReply<>: cast to 'QString' error
WARNING: DCOPReply<>: cast to 'QString' error
X Error: BadWindow (invalid Window parameter) 3
  Major opcode:  20
  Minor opcode:  0
  Resource id:  0x0
WARNING: DCOPReply<>: cast to 'QString' error
WARNING: DCOPReply<>: cast to 'QString' error
WARNING: DCOPReply<>: cast to 'QString' error

Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


